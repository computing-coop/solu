@cache_dir = 'lib/assets/'
@scope = 'arsbioarctica'

def hash_from_cache
  xml = @cache_dir + 'export.xml'
  cache = @cache_dir + 'export.cache.rb'

  if ! File.exists?(cache)
    data = File.read xml
    hash = Hash.from_xml data
    File.open(cache, "wb") {|io| Marshal.dump(hash, io)}
  else
    hash = File.open(cache, "rb") {|io| Marshal.load(io)}
  end

end


def get_tagged_posts(hash)
  begin
    hash['rss']['channel']['item'].select do |item|
      categories = item['category']
     next if categories.nil?
      if categories.class == String
      
        categories = [categories]
      end
      ['Aside','Main'].each do |ignore|
        if index = categories.index(ignore)
          categories.delete_at index
        end
      end
      categories.length > 1
    end
  rescue
    nil
  end
end

def get_thumbnail_image(post)

  # look for thumbnail if exists
  thumb = 0
  if post['postmeta'].class != Hash && !post['postmeta'].nil?
    post['postmeta'].each do |h|
      if h["meta_key"] == "_thumbnail_id"
        thumb = h["meta_value"]
      end
    end
  end
  if thumb != 0
    master_image = Photo.where(:wordpress_id => thumb, wordpress_scope: @scope)
    unless master_image.empty?
      master_image.id
    end
  end
end

def get_formated_content(post)
  content = post['encoded'].first

  # remove comments
  comment_regex = /([<!\-\-].*?[\-\-]\s*>)/
  content.gsub!(comment_regex, '')

  # convert caption blocks to real HTML
  caption_regex = /\[caption .*\](?<image><(a|strong|img)(.*)>)(?<caption>(.*))\[\/caption\]/
  caption_replace = '<figure>\k<image><figcaption>\k<caption></figcaption></figure>'
  content.gsub!(caption_regex,caption_replace)

  image_regex = /^(?<image>(<(a |strong)(.*)>)?<img (.*)\/>(<\/(a|strong)>)?)/
  image_replace = '<figure>\k<image></figure>'
  content.gsub!(image_regex,image_replace)

  content
end

def get_formatted_excerpt(post)
  content = post['encoded'].last
  unless content.blank?
    # TODO
    # convert first photo to Model
    # wrap with <p>'s

    # remove comments
    comment_regex = /([<!\-\-].*?[\-\-]\s*>)/
    content.gsub!(comment_regex, '')

    # convert caption blocks to real HTML
    caption_regex = /\[caption .*\](?<image><(a|strong|img)(.*)>)(?<caption>(.*))\[\/caption\]/
    caption_replace = '<figure>\k<image><figcaption>\k<caption></figcaption></figure>'
    content.gsub!(caption_regex,caption_replace)

    image_regex = /^(?<image>(<(a |strong)(.*)>)?<img (.*)\/>(<\/(a|strong)>)?)/
    image_replace = '<figure>\k<image></figure>'
    content.gsub!(image_regex,image_replace)
  end
  content
end


def get_photo(post)
  first_photo_regex = /<img.+src=['"]([^'"]+)['"].*>/
  post['encoded'][0][first_photo_regex, 1]
end

def get_tags(post)
  tags = post['category']
  if tags.class == String
    tags = [tags]
  end
  # remove useless tags
  ['Aside','Main'].each do |ignore|
    if index = tags.index(ignore)
      tags.delete_at index
    end
  end
  # convert 'foo + bar' into seperate tags
  tags.collect! do |tag|
    bits = tag.split ' + '
    tag = bits.shift
    bits.each { |b| tags.push b }
    tag
  end
  # tags.push('wp-import')
end

namespace :after_import do
  task update_links: :environment do
    # pages first
    string_to_replace = /http:\/\/bioartsociety\.fi\/making_life\/([^\"\'\/]*)/
    # project = Project.find('field-notes')
    
    Page.all.each do  |p|

      p.body.gsub!(string_to_replace) {
        match = Regexp.last_match[1]
        unless match.nil?
          STDERR.puts 'atcb is ' + match
          unless match =~ /wp\-content/ || match =~ /^category/
            # look for post
            
            posts = Post.where(project: project).find(match) rescue nil
            if posts.nil?
              pages = Page.where(project: project).find(match) rescue nil
              if pages.nil?
                STDERR.puts 'cannot find ' + match
                match
              else
                STDERR.puts ' -- rewriting to ' + "/pages/#{pages.slug}"
                "/pages/#{pages.slug}"
              end
            else
              STDERR.puts ' -- rewriting to ' + "/posts/#{posts.slug}"
              "/posts/#{posts.slug}"
            
            end
          end
          
        end
      }
    end
  end
end
        
      
    

namespace :wordpress do

  task :cache => :environment do
    hash = hash_from_cache

    # write authors to cache
    # authors = get_authors(hash)
    # cache = @cache_dir + 'authors.cache.rb'
    # File.open(cache, "wb") { |io| Marshal.dump(authors, io) }

    # write posts to cache
    posts = get_tagged_posts(hash)
    cache = @cache_dir + 'posts.cache.rb'
    File.open(cache, "wb") { |io| Marshal.dump(posts, io) }
  end

  task :categories => :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    hash['rss']['channel']['category'].each do |c|
      PostCategory.create(:name => c['cat_name'], :slug => c['category_nicename'], :wordpress_id => c['term_id'])
    end
  end
  
  task videos: :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    hash['rss']['channel']['item'].each do |i|
      next unless i['post_type'] == 'attachment'
      unless i['attachment_url'].blank?
        next unless i['attachment_url'] =~ /mov/i || i['attachment_url'] =~ /mp4/i || i['attachment_url'] =~ /avi/i
        post = Post.where(wordpress_id: i['post_parent'], wordpress_scope: @scope)
        if post.empty?
          # look for a page
          page = Page.where(wordpress_id: i['post_parent'], wordpress_scope: @scope)
          if page.empty?
            p 'cannot find parent for ' + i['post_parent']
          else
            page = page.first
            basename = File.basename(URI.parse(i['attachment_url']).path) rescue next
            if page.videos.map{|x| x['videofile']}.include?(basename)
              p ' among ' + page.videos.map{|x| x['videofile']}.join(', ')
            else
              p 'no ' + basename + ' in ' + page.videos.map{|x| x['videofile']}.join('/')
              page.videos << Video.new(:remote_videofile_url => i['attachment_url'], videographic: page, :wordpress_id => i['post_id'], :wordpress_scope => @scope ) 
              p 'put video on page # ' + post.slug
            end
          end
        else
          post = post.first
          basename = File.basename(URI.parse(i['attachment_url']).path) rescue next
          # p 'creating photo for for ' + i['post_id']
          if post.videos.map{|x| x['videofile']}.include?(basename)
            p ' among ' + post.videos.map{|x| x['videofile']}.join(', ')
          else
            p 'no ' + basename + ' in ' + post.videos.map{|x| x['videofile']}.join('/')
            post.videos << Video.new(:remote_videofile_url => i['attachment_url'], videographic: post, :wordpress_id => i['post_id'], :wordpress_scope => @scope ) 
            p 'put video on post # ' + post.slug
          end
        end
      end
    end
  end
  

  task soundfiles: :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    hash['rss']['channel']['item'].each do |i|
      next unless i['post_type'] == 'attachment'
      unless i['attachment_url'].blank?
        next unless i['attachment_url'] =~ /mp3/i || i['attachment_url'] =~ /m4a/i
        post = Post.where(wordpress_id: i['post_parent'], wordpress_scope: @scope)
        if post.empty?
          # look for a page
          page = Page.where(wordpress_id: i['post_parent'], wordpress_scope: @scope)
          if page.empty?
            p 'cannot find parent for ' + i['post_parent']
          else
            page = page.first
            basename = File.basename(URI.parse(i['attachment_url']).path) rescue next
            if page.soundfiles.map{|x| x['soundfile']}.include?(basename)
              p ' among ' + page.soundfiles.map{|x| x['soundfile']}.join(', ')
            else
              p 'no ' + basename + ' in ' + page.soundfiles.map{|x| x['soundfile']}.join('/')
              page.soundfiles << Soundfile.new(:remote_soundfile_url => i['attachment_url'], soundable: page, :wordpress_id => i['post_id'], :wordpress_scope => @scope ) 
              p 'put sound on page # ' + post.slug
            end
          end
        else
          post = post.first
          basename = File.basename(URI.parse(i['attachment_url']).path) rescue next
          # p 'creating photo for for ' + i['post_id']
          if post.soundfiles.map{|x| x['soundfile']}.include?(basename)
            p ' among ' + post.soundfiles.map{|x| x['soundfile']}.join(', ')
          else
            p 'no ' + basename + ' in ' + post.soundfiles.map{|x| x['soundfile']}.join('/')
            post.soundfiles << Soundfile.new(:remote_soundfile_url => i['attachment_url'], soundable: post, :wordpress_id => i['post_id'], :wordpress_scope => @scope ) 
            p 'put sound on post # ' + post.slug
          end
        end
      end
    end
  end
  
  task :attachments => :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    hash['rss']['channel']['item'].each do |i|
      next unless i['post_type'] == 'attachment'
      unless i['attachment_url'].blank?
        # get post
        post = Post.where(wordpress_id: i['post_parent'], wordpress_scope: @scope)
        # p 'need to put attachement ' + i['attachment_url'] + ' to post ' + i['post_parent']
        if post.empty?
          # look for a page
          page = Page.where(wordpress_id: i['post_parent'], wordpress_scope: @scope)
          if page.empty?
            p 'cannot find parent for ' + i['post_parent']
          else
            page = page.first
            basename = File.basename(URI.parse(i['attachment_url']).path) rescue next
            if page.photos.map{|x| x['image']}.include?(basename)
              p ' among ' + page.photos.map{|x| x['image']}.join(', ')
            else
              p 'no ' + basename + ' in ' + page.photos.map{|x| x['image']}.join('/')
              page.photos << Photo.new(:remote_image_url => i['attachment_url'], photographic: page, :wordpress_id => i['post_id'], :wordpress_scope => @scope ) 
            end
          end
        else
          post = post.first
          basename = File.basename(URI.parse(i['attachment_url']).path) rescue next
          # p 'creating photo for for ' + i['post_id']
          if post.photos.map{|x| x['image']}.include?(basename)
            p ' among ' + post.photos.map{|x| x['image']}.join(', ')
          else
            p 'no ' + basename + ' in ' + post.photos.map{|x| x['image']}.join('/')
            post.photos << Photo.new(:remote_image_url => i['attachment_url'], photographic: post, :wordpress_id => i['post_id'], :wordpress_scope => @scope ) 
          end
        end
      end
    end
  end

  task :map_page_tree => :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    hash['rss']['channel']['item'].each do |p|
      next unless p['post_type'] == 'page'
      next if p['post_parent'] == "0"
      # get page in new database
      par =  Page.where(:wordpress_id => p['post_parent'], :wordpress_scope => @scope)
      if par.empty?
        next
      else
        new_db = Page.find_by(:wordpress_id => p['post_id'], :wordpress_scope => @scope) rescue next
        new_db.parent = par.first
        new_db.save
      end
    end
  end

  task :pages => :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    bioartnode = Node.find('bioart')
    # makinglife = Project.find('field-notes')
    hash['rss']['channel']['item'].each do |p|
      next unless p['post_type'] == 'page'
      page = Page.create(
        title: p['title'],
        subsite_id: 1,
        published: p['status'] == 'draft' ? false : true,
        body: get_formated_content(p),
        wordpress_id: p['post_id'],
        wordpress_author: p['post_creator'],
        wordpress_scope: @scope,
        created_at: p['pubDate'],
        updated_at: p['pubDate'],
        node: bioartnode
        # project: makinglife

      )
    end
  end

  task :associate_secondary_images => :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data

    # to be run after importing attachments and posts, so primary images should be
    # deleted from the photos table, leaving only secondary images
    hash['rss']['channel']['item'].each do |i|
      next unless i['post_type'] == 'attachment'

      # get entry in photo table
      photo_entry = Page.all.map(&:photos).flatten.delete_if{|x| x.wordpress_id != i['post_id'] && x.wordpress_scope != @scope}
      next if photo_entry.empty?  # we deleted it as it's a primary image post
      # check for existence of parent post
      parent_post = Page.where(:wordpress_id => i['post_parent'], wordpress_scope: @scope)
      if parent_post.empty?
        next
      else
        parent_post  = parent_post.first
      end
      if parent_post.photos.include?(photo_entry)
        # it's already here so don't put it twice
        
        next
      else
        parent_post.photos << photo_entry
        parent_post.save!
      end

    end
  end

  task :posts => :environment do
    xml = @cache_dir + 'export.xml'
    data = File.read xml
    hash = Hash.from_xml data
    # cats = PostCategory.all.map{|x| [x.name, x.id] }
    # Post.paper_trail_off!
    bioartnode = Node.find('bioart')
    # makinglife = Project.find('field-notes')
    hash['rss']['channel']['item'].each do |p|
     

      next unless p['post_type'] == 'post'

      next unless Post.where(:wordpress_id => p['post_id']).empty?

      # author = User.find_by_username(p['creator'])
      article = Post.create(
        title: p['title'],
        body: get_formated_content(p),
        short_abstract: get_formatted_excerpt(p),
        published_at: p['pubDate'],
        wordpress_id: p['post_id'],
        wordpress_author: p['creator'],
        wordpress_scope: @scope,
        user: User.find_by(email: 'erich.berger@bioartsociety.fi'),
        node: bioartnode,
        published: p['status'] == 'draft' ? false : true
        # tag_list: get_tags(p),
        # project: makinglife
      )
      ti = get_thumbnail_image(p)
      if ti
        p 'found photo for ' + p['post_id']
        photo = Photo.find(ti)
        article.remote_image_url = photo.image.url
        photo.destroy
      end
      article.postcategory_ids =  p['category'].blank? ? false : ( p['category'].class == Array ? p['category'].map{|x| cats.find{|y| y.first == x }.last } : [cats.find{|y| y.first == p['category']}.last] ) rescue []
      article.save(validate: false)
    end
  end



  task migrate_images: :environment do
    
    Post.where(wordpress_scope: @scope).each do |post|
      next if post.body.nil?
      matches = post.body.scan(/['"]((https?):\/\/(www\.:?)kilpiscope\.net\/residency\/wp-content[^"]+)/).map(&:first).uniq
      matches.each do |image_url|
        next if image_url =~ /mp3$/ || image_url =~ /mov$/ || image_url =~ /mp4$/
        image_url =  image_url.gsub(/\-\d{3,4}x\d{3,4}(\.\w\w\w)\s*$/, '\1')
        # p ' '
        # p ' '
        # p File.basename(image_url) + ":"
        # p '----'
        unless post.photos.map{|x| x['image']}.include?(File.basename(image_url))
          begin
            post.photos << Photo.new(:remote_image_url => image_url,
                           photographic: post, 
                            :wordpress_scope => @scope ) 
            p 'getting photo ' + image_url + ' and adding to post ' + post.slug
          rescue
            p 'cannot find photo: ' + image_url + ' in post ' + post.slug
          end
        end
      end
    end
  end

  #       # check to see if it's already in our database
        # existing = Ckeditor::Asset.find_by(wordpress_url: image_url)
  #
  #       # new record so grab url and save and mark if missing
  #       if existing.nil?
  #         ck = Ckeditor.picture_model.new
  #
  #         # if it ends in something like -660x371 try to get original
  #         if image_url =~ /\-\d\d\dx\d\d\d\.(jpe?g|png|gif)$/
  #           first_try = image_url.gsub(/\-\d\d\dx\d\d\d\./, '.')
  #           ck.remote_data_url = first_try
  #           ck.wordpress_url = image_url
  #           if !ck.save
  #             ck.remote_data_url = image_url
  #           end
  #         else
  #           ck.remote_data_url = image_url
  #         end
  #
  #         ck.wordpress_url = image_url
  #         begin
  #           ck.save!
  #         rescue ActiveRecord::RecordInvalid
  #             ck.remote_data_url = 'http://bioartsociety.fi/wp-content/uploads/2013/10/kilpis_cano.jpg'
  #             ck.missing = true
  #             ck.save!
  #         end
  #         existing = ck
  #       end
  #
  #       # already exists so just replace with correct URL
  #       post.body.gsub!(image_url, existing.data.url)
  #       if existing.missing
  #         puts "broken URL: #{image_url}"
  #       else
  #         puts "replaced #{image_url} with #{existing.data.url} for Post ##{post.post_id}"
  #       end
  #       # doc = Nokogiri::HTML.fragment(post.body)
  #       # doc.search('figure').each do |a|
  #       #   a.replace(a.content)
  #       # end
  #       # post.body = doc.to_html
  #       post.body.gsub!(/<\/?figure>/, '')
  #
  #       post.save(validate: false)
  #     end  # end of matches.each loop
  #     unless post.globalized_model.image? || matches.empty?
  #       d = Ckeditor::Asset.find_by(wordpress_url: matches.first)
  #       unless d.missing == true
  #         post.globalized_model.remote_image_url = d.data.url
  #         post.globalized_model.save!
  #         puts "Post ##{post.post_id} was missing image, now has #{d.data.url}"
  #       end
  #     end
  #
  #   end
  # end



  task :convert_page_line_breaks => :environment do
    # ActiveRecord::Base.record_timestamps = false
    begin
      Page.where(:wordpress_scope => @scope).each do |p|
        next if p.body.nil?
        p.body = p.body.gsub(/(?:\n\r?|\r\n?)/, '<br />')
        p.save! rescue p.id
      end
    ensure
      # ActiveRecord::Base.record_timestamps = true
    end
  end

  task :convert_line_breaks => :environment do

    begin
      Post.where(:wordpress_scope => @scope).each do |p|
        next if p.body.nil?
        p.body = p.body.gsub(/(?:\n\r?|\r\n?)/, '<br>')
        p.save! rescue p.id
      end
    ensure
      # ActiveRecord::Base.record_timestamps = true
    end
  end
end




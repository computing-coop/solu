#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "HYBRID MATTERs"
    xml.author "HYBRID MATTERs"
    xml.description "News and events from the HYBRID MATTERs project"
    xml.link "https://www.hybridmatters.net"
    xml.language "en"

    for article in @posts
      xml.item do
        xml.title article.title
        xml.author article.user.email + " #{article.user.name})"
        xml.link "http://hybridmatters.net" + post_path(article)
        xml.guid "http://hybridmatters.net" + post_path(article)
        xml.pubDate article.published_at.to_s(:rfc822)

        text = article.body
		# if you like, do something with your content text here e.g. insert image tags.
		# Optional. I'm doing this on my website.
        unless article.photos.empty?
          article.photos.each do |item|
            image_url = item.image.url(:standard)
            image_tag = "
                <p><img src='" + image_url +  "' /></p>
              "
            text = image_tag + text
          end
        end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end
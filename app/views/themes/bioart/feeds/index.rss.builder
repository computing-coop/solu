#encoding: UTF-8

xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Bioartsociety"
    xml.author "Suomen Biotaiteen Seura/Finnish Bioart Society"
    xml.description "News and activities of the Finnish Bioart Society"
    xml.link "https://www.bioartsociety.fi"
    xml.language "en"

    for article in @feed
      xml.item do
        xml.title article.title
        xml.author article.user.name
        xml.link "https://bioartsociety.fi" + post_path(article)
        xml.guid "https://bioartsociety.fi" + post_path(article)

        xml.pubDate article.published_at.to_s(:rfc822)

        text = article.body
		# if you like, do something with your content text here e.g. insert image tags.
		# Optional. I'm doing this on my website.
        unless article.photos.empty?
            image_url = article.photos.first.image.url(:standard)
            image_tag = "
                <p><img src='" + image_url +  "' /></p>
              "
            text = image_tag + text
        end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end
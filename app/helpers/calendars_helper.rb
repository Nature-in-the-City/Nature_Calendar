module CalendarsHelper
  def process_body(body)
    replace_wrapper(body)
    insert_calendar(body)
    replace_image(body)
    link_social_icons(body)
    absolutize_links(body)
    raw body
  end

  def replace_wrapper(body)
    square_space_wrapper = render 'shared/squarespace_wrapper'
    elem = body.at_css('#page').first_element_child
    elem.replace square_space_wrapper
  end

  def insert_calendar(body)
    calendar = render 'calendar'
    elem = body.at_css('#block-yui_3_17_2_6_1436507156755_8418 .sqs-block-content')
    elem.add_child calendar
  end

  def replace_image(body)
    square_space_image = render 'shared/squarespace_image'
    elem = body.at_css('#hero')
    elem.replace square_space_image
  end

  def link_social_icons(body)
    url = File.join(Rails.root, 'lib', 'squarespace_svgs.rb')
    svgs = eval(File.read(url))
    keys = svgs.keys
    social_icons = body.css('.sqs-svg-icon--list svg')
    if not social_icons.nil? then
      social_icons.each_with_index do |elem, index|
        data = svgs[keys[index]]
        if not data.nil? then
          elem.child.replace  data[:background]
          elem.child.next.replace  data[:icon]
          elem.child.next.next.replace  data[:mask]
        end
      end
    end
  end

  def absolutize_links(body)
    absolutize_collection(body.css('#upper-logo a'))
    absolutize_collection(body.css('#topNav .page-collection a'))
    absolutize_collection(body.css('#mobileNav .page-collection a'))
  end

  def absolutize_collection(array)
    base = 'http://natureinthecity.org'
    array.each do |elem|
      path = elem['href']
      elem['href'] = (base + path) unless path.include?(base)
    end
  end

  def process_head(head)
    head.at_css('title').content = 'Calendar — Nature in the City'
    remove_scripts(head)
    raw head
  end

  def remove_scripts(head)
    head.css('script').each do |elem|
      elem.remove unless elem['type'] == 'text/javascript'
    end
  end
end
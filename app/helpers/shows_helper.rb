module ShowsHelper
  def format_date(date)
    if date.nil?
      ''
    else
      ii = date.to_i
      time = Time.at(ii / 1000).utc
      date = time.to_date
      date.strftime('%A %B %d, %Y')
    end
  end

  def read_date(date)
    if date.nil?
      nil
    else
      ii = date.to_i
      time = Time.at(ii / 1000).utc
      date = time.to_date
    end
  end

  # Options
  #  1. City, State
  #  2. City, Country
  #  3. City
  # Builds an address from a hubspot show.
  def address_builder(show)
    if show[:venue_city] && show[:venue_state]
      unless show[:venue_state].casecmp?('n/a')
        "#{show[:venue_city]}, #{show[:venue_state]}"
      end
    elsif show[:venue_city] && show[:venue_country]
      "#{show[:venue_city]}, #{show[:venue_country]}"
    elsif show[:venue_city]
      show[:venue_city]
    end
  end

  # Check if a deal is issued in hubspot.
  def deal_stage(stage)
    issued = '323905d1-2784-4fc5-b4bd-d544348f2668'
    'issued' if stage == issued
  end

  # Creates an extras code for an artist's calendar.
  def hubspot_extras_code(show)
    code = ''
    code += '%' unless show[:backend].downcase.include? 'flat'
    code += 'H' unless show[:hotel].downcase.include? 'n/a'
    unless show[:local_ground_transportation].nil?
      unless show[:local_ground_transportation].downcase.include? 'n/a'
        code += 'G'
      end
    end
    unless show[:backline].nil?
      code += 'B' unless show[:backline].downcase.include? 'n/a'
    end
    code
  end
end

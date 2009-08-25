module SectionHelpers
  def xpath_of_section(section_name, prefix = "//")
    case section_name

    when /calendar on day "(\d+)"/i
      "#{prefix}p[contains(@class, 'day')][contains(., #{$1})]/.."
    else
      raise "Can't find mapping from \"#{section_name}\" to a section."
    end
  end
end

World(SectionHelpers)

module ApplicationHelper

  def page_is?(page)
    return false unless page._?.to_s.is_a?(String)
    @controller_name, @action_name = *page.to_s.split('/')
    return (params[:controller] == @controller_name && params[:action] == @action_name) if @action_name
    return (params[:controller] == @controller_name)
  end

  def reports?
    (params[:reports] == 'true')
  end

      def radio_buttons(container, selected = nil)
        return container if String === container

        selected, disabled = extract_selected_and_disabled(selected).map do | r |
           Array.wrap(r).map { |item| item.to_s }
        end

        container.map do |element|
          html_attributes = option_html_attributes(element)
          text, value = option_text_and_value(element).map { |item| item.to_s }
          selected_attribute = ' checked="checked"' if option_value_selected?(value, selected)
          disabled_attribute = ' disabled="disabled"' if disabled && option_value_selected?(value, disabled)
          %(<label class="radio"><input type="radio" value="#{ERB::Util.html_escape(value)}"#{selected_attribute}#{disabled_attribute}#{html_attributes}>#{ERB::Util.html_escape(text)}</label>)
        end.join("\n").html_safe

      end

end

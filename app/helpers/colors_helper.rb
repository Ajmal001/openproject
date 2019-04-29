#-- encoding: UTF-8

#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2018 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

module ColorsHelper
  def options_for_colors(colored_thing, allow_bright_colors)
    colors = []
    Color.find_each do |c|
      next if !allow_bright_colors && c.bright?

      options = {}
      options[:name] = c.name
      options[:value] = c.id
      options[:data] = {
        color: c.hexcode,
        bright: c.bright?,
        background: c.contrasting_color(light_color: 'transparent')
      }
      options[:selected] = true if c.id == colored_thing.color_id

      colors.push(options)
    end
    colors.to_json
  end

  def darken_color(hex_color, amount = 0.4)
    hex_color = hex_color.delete('#')
    rgb = hex_color.scan(/../).map(&:hex)
    rgb[0] = (rgb[0].to_i * amount).round
    rgb[1] = (rgb[1].to_i * amount).round
    rgb[2] = (rgb[2].to_i * amount).round
    "#%02x%02x%02x" % rgb
  end

  def colored_text(color)
    background = color.contrasting_color(dark_color: '#333', light_color: 'transparent')
    style = "background-color: #{background}; color: #{color.hexcode}"
    content_tag(:span, color.hexcode, class: 'color--text-preview', style: style)
  end

  def color_css
    Color.find_each do |color|
      concat ".__hl_inline_color_#{color.id}_dot::before { background-color: #{color.hexcode} !important;}"
      concat ".__hl_inline_color_#{color.id}_dot::before { border: 1px solid #555555 !important;}" if color.bright?
      concat ".__hl_inline_color_#{color.id}_text { color: #{color.hexcode} !important;}"
      concat ".__hl_inline_color_#{color.id}_text { -webkit-text-stroke: 0.5px grey;}" if color.super_bright?
    end
  end

  def resource_color_css(name, scope)
    scope.includes(:color).find_each do |entry|
      color = entry.color

      if color.nil?
        concat ".__hl_inline_#{name}_#{entry.id}::before { display: none }\n"
        next
      end

      styles = color.color_styles

      background_style = styles.map { |k,v| "#{k}:#{v} !important"}.join(';')
      border_color = color.bright? ? '#555555' : color.hexcode

      if name === 'type'
        concat ".__hl_inline_#{name}_#{entry.id} { color: #{color.hexcode} !important;}"
        concat ".__hl_inline_#{name}_#{entry.id} { -webkit-text-stroke: 0.5px grey;}" if color.super_bright?
      else
        concat ".__hl_inline_#{name}_#{entry.id}::before { #{background_style}; border-color: #{border_color}; }\n"
      end

      concat ".__hl_background_#{name}_#{entry.id} { #{background_style}; }\n"

      # Mark color as bright through CSS variable
      # so it can be used to add a separate -bright class
      unless color.bright?
        concat ":root { --hl-#{name}-#{entry.id}-dark: #{styles[:color]} }\n"
      end
    end
  end

  def icon_for_color(color, options = {})
    return unless color

    options.merge! class: 'color--preview ' + options[:class].to_s,
                   title: color.name,
                   style: "background-color: #{color.hexcode};" + options[:style].to_s

    content_tag(:span, ' ', options)
  end
end

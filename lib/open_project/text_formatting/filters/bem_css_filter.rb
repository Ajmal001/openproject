#-- encoding: UTF-8

#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2020 the OpenProject GmbH
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

module OpenProject::TextFormatting
  module Filters
    class BemCssFilter < HTML::Pipeline::Filter
      BEM_CLASSES = {
        h1: 'op-uc-h1',
        h2: 'op-uc-h2',
        h3: 'op-uc-h3',
        h4: 'op-uc-h4',
        h5: 'op-uc-h5',
        h6: 'op-uc-h6'
      }.with_indifferent_access.freeze

      def call
        doc.search(*BEM_CLASSES.keys.map(&:to_s)).each do |element|
          element['class'] = BEM_CLASSES[element.name]
        end

        doc
      end
    end
  end
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def downcase_website
    website.downcase!
  end
end

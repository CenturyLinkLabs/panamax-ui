require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name, :description, :keywords
  attr_writer :author, :user, :icon

  def author
    @author || @user.try(:email)
  end

  def icon
    @icon || self.class.icon_options['Docker Blocks']
  end

  def save
    if valid?
      Template.create(
        name: name,
        description: description,
        keywords: keywords,
        authors: [author],
        icon: icon
      )
    end
  end

  def self.icon_options
    {
      'Docker Blocks' => 'http://panamax.ca.tier3.io/template_logos/default.png',
      'Wordpress' => 'http://panamax.ca.tier3.io/template_logos/wordpress.png',
      'Tomcat' => 'http://panamax.ca.tier3.io/template_logos/tomcat.png',
      'Rails' => 'http://panamax.ca.tier3.io/template_logos/rails.png',
      'NodeJS' => 'http://panamax.ca.tier3.io/template_logos/nodejs.png',
      'MySQL' => 'http://panamax.ca.tier3.io/template_logos/mysql.png',
      'Magento' => 'http://panamax.ca.tier3.io/template_logos/magento.png',
      'LAMP' => 'http://panamax.ca.tier3.io/template_logos/lamp.png',
      'Java' => 'http://panamax.ca.tier3.io/template_logos/java.png',
      'HuBot' => 'http://panamax.ca.tier3.io/template_logos/hubot.png',
      'Drupal' => 'http://panamax.ca.tier3.io/template_logos/drupal.png',
      'Django' => 'http://panamax.ca.tier3.io/template_logos/django.png',
      'Apache' => 'http://panamax.ca.tier3.io/template_logos/apache.png',
      'Ubuntu' => 'http://panamax.ca.tier3.io/template_logos/ubuntu.png',
      'Go' => 'http://panamax.ca.tier3.io/template_logos/go.png'
    }
  end
end

require 'rubygems'
require 'net/http'
require 'xmlsimple'
require 'activesupport'
require File.dirname(__FILE__) + '/harvest_entry'

class Harvest
  VERSION = '0.1.0'
  
  def initialize(domain, email, password)
    @domain = domain
    @email = email
    @password = password
  end

  def users(params={})
    request("/people", params).users
  end

  def projects
    request("/projects").projects
  end

  def report(from, to, project_and_or_person_id)
    entries = []
    if project_and_or_person_id.has_key?(:project_id)
      entries += request("/projects/#{project_and_or_person_id[:project_id]}/entries?from=#{from.strftime("%Y%m%d")}&to=#{to.strftime("%Y%m%d")}").day_entries
    end
    
    if project_and_or_person_id.has_key?(:person_id)
      entries += request("/people/#{project_and_or_person_id[:person_id]}/entries?from=#{from.strftime("%Y%m%d")}&to=#{to.strftime("%Y%m%d")}").day_entries
    end
    
    entries
  end
  
  def tasks(task_id=nil)
    if task_id.nil?
      request("/tasks").tasks    
    else
      request("/tasks/#{task_id}")
    end
  end

private
  def request(path, params={})
    request = Net::HTTP::Get.new(path, { "Accept" => "application/xml"})
    request.basic_auth(@email, @password)
    request.content_type = "application/xml"
    ret = nil
    Net::HTTP.new(@domain).start {|http| 
      response = http.request(request)
      ret = HarvestEntry.new(XmlSimple.xml_in(response.body))
    }
    ret
  end
end
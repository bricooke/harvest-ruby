require 'rubygems'
require 'net/http'
require 'xmlsimple'
require 'activesupport'
require File.dirname(__FILE__) + '/harvest_entry'

class Harvest
  VERSION = '0.1.1'
  @tasks = []
  @expenses = []
  
  def initialize(domain, email, password)
    @domain = domain
    @email = email
    @password = password
  end

  # returns all the users created in this Harvest account
  # see http://www.getharvest.com/api/people for data available
  def users(params={})
    request("/people", params).users
  end

  # returns all the projects created in this Harvest account
  # see http://www.getharvest.com/api/projects for data available
  def projects
    request("/projects").projects
  end

  # returns all tasks and expenses for a given project or person
  # in the given time period. The expenses and entries are
  # mixed in the same array returned. Use .expense? to determine 
  # what type it is. Reference http://www.getharvest.com/api/reporting
  # to get data available for each type
  def report(from, to, project_and_or_person_id)
    entries = []
    
    %w(entries expenses).each do |type|
      if project_and_or_person_id.has_key?(:project_id)
        t = request("/projects/#{project_and_or_person_id[:project_id]}/#{type}?from=#{from.strftime("%Y%m%d")}&to=#{to.strftime("%Y%m%d")}")
        temp = (type == "entries" ? t.day_entries : t.expenses)
        entries += temp.select {|entry| !(entries.any? {|match| match.id == entry.id })}
      end
    
      if project_and_or_person_id.has_key?(:person_id)
        t = request("/people/#{project_and_or_person_id[:person_id]}/#{type}?from=#{from.strftime("%Y%m%d")}&to=#{to.strftime("%Y%m%d")}")
        temp = (type == "entries" ? t.day_entries : t.expenses)
        entries += temp.select {|entry| !(entries.any? {|match| match.id == entry.id })}
      end
    end
    entries
  end
  
  # returns all tasks and caches the results
  # see http://www.getharvest.com/api/tasks
  def tasks
    @tasks ||= request("/tasks").tasks
  end
  
  # return a specific task
  # see http://www.getharvest.com/api/tasks
  def task(id)
    self.tasks.find {|t| t.id.to_i == id.to_i}
  end

  # returns all expense categories and caches the results
  # see http://www.getharvest.com/api/expenses
  def expense_categories
    @expense_categories ||= request("/expense_categories").expense_categories
  end
  
  # returns a specific expense_category
  # see http://www.getharvest.com/api/expenses
  def expense_category(id)
    self.expense_categories.find {|e| e.id.to_i == id.to_i}
  end

private
  def request(path, params={})
    request = Net::HTTP::Get.new(path, { "Accept" => "application/xml"})
    request.basic_auth(@email, @password)
    request.content_type = "application/xml"
    ret = nil
    Net::HTTP.new(@domain).start {|http| 
      response = http.request(request)
      if response.class == Net::HTTPServiceUnavailable
        raise ArgumentError, "API Limit exceeded. Retry after #{response["Retry-After"].to_i/60} minutes."
      end
      ret = HarvestEntry.new(XmlSimple.xml_in(response.body))
    }
    ret
  end
end
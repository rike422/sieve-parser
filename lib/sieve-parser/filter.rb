# -*- coding: UTF-8 -*-
# This class implements a parse of sieve filter and returns a object
# to manipulate
# @author Thiago Coutinho<thiago @ osfeio.com>(selialkile)
# @note This code folow de "THE BEER-WARE LICENSE"
module Sieve
  class Filter

    #@note [join] can be: any, allof or anyof
    attr_accessor :name, :type, :join, :disabled, :text

    # Initialize the class
    #@param [String](:text) String of filter text
    #@param [Array](:conditions) Array of Conditions
    #@param [Array](:actions) Array of Actions
    #@return [object] Object of self
    def initialize params={}
      @text = params[:text]
      @conditions = (params[:conditions]) ? params[:conditions] : []
      @actions = (params[:actions]) ? params[:actions] : []
      parse unless @text.nil?
    end

    # Return the conditions of filter
    #@return [array] conditions
    def conditions
      @conditions
    end

    # Return the actions of filter
    #@return [array] actions
    def actions
      @actions
    end

    # Return name of filter
    # @return [string] name of filter
    def name
      @name
    end

    # Add object of Action to filter
    #@param [Sieve::Action]
    def add_action(action)
      raise "the param is not a Action" unless action.class.to_s == "Sieve::Action"
      @actions << action
    end

    # Add object of Condition to filter
    #@param [Sieve::Condition]
    def add_condition(condition)
      raise "the param is not a Condition" unless condition.class.to_s == "Sieve::Condition"
      @conditions << condition
    end

    # Return a text of filter
    #@return [string] text of filter
    def to_s
      text = "# #{name}\n"
      text += ((disabled?) ? "false #" : "") + "#{@type}"
      if conditions.count > 1
        text += " #{@join} (" + conditions.join(", ") + ")"
      else
        text += " " + conditions[0].to_s
      end
      text += "\n{\n\t"
      text += actions.join("\n\t")
      text += "\n}\n"
    end

    # Is disabled or not? Return the status of filter
    #@return [boolean] true for disabled and false for enabled
    def disabled?
      @disabled == true
    end

    def disable!
      @disabled = true
    end

    private
    # Parse conditions, call the parse_common or parse_vacation
    def parse
      #regex_rules_params = "(^#.*)\nif([\s\w\:\"\.\;\(\)\,\-]+)\{([\@\<>=a-zA-Z0-9\s\[\]\_\:\"\.\;\(\)\,\-\/]+)\}$"
      #regex_rules_params2 = "(^#.*)\n(\S+)(.+)\n\{\n([\s\S]*)\}"
      parts = @text.scan(/(^#.*)\n(\S+)\s(.+)\n\{\n([\s\S]*;)\n\}/)[0]
      parse_name(parts[0])
      @type = parts[1]

      self.disable! if parts[2] =~ /.*false #/
      #if the join is true, dont have conditions...
      if parts[2] =~ /true/
        @conditions << Condition.new(type:"true")
      elsif parts[2] =~ /(anyof|allof)/
        @join = parts[2][/^\S+/]
        @conditions.concat(Condition.parse_all( parts[2].scan(/\(([\S\s]+)\)/)[0][0] ))
      else
        @conditions << Condition.new(text:parts[2])
      end

      @actions.concat(Action.parse_all(parts[3]))
    end


    def parse_name(text_name)
      @name = text_name.match(/#(.*)/)[1].strip
    end
  end

end
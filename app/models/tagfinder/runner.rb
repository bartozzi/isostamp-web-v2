module Tagfinder
  class Runner
    URL = ENV['EC2_URL']
    KEY = ENV['EC2_KEY']

    include Procto.call, Concord.new(:execution, :connection)

    private_class_method :new

    def call
      response = JSON.parse(connection.call(Request.new(URL, execution_params)))
      log_output(response)
      log_results(response)
      execution
    end

    private

    def log_results(response)
      return unless successful?(response)
      response.fetch('results_urls').each do |url|
        ResultsFile.create!(
          filename:            File.basename(url)[37..-1],
          direct_upload_url:   url,
          tagfinder_execution: execution
        )
      end
    end

    def log_output(response)
      logged = { tagfinder_execution: execution }
      execution.update_attributes(success: successful?(response))

      puts 'history:'.black
      ap response['history']
      puts 'successful?:'.black
      puts successful?(response)

      if successful?(response)
        response.fetch('history').each { |h| HistoryOutput.create!(logged.merge(h)) }
      else
        response.fetch('history').each { |h| HistoryOutput.create!(logged.merge(h)) }
        execution.log(response['error'])
      end
    end

    def successful?(response)
      return false if response['history'].nil?
      response['history'].map { |output| output['status'] }.reduce(&:|).zero?
    end

    def execution_params
      default_params =
        {
          data_url: execution.data_file.direct_upload_url,
          key:      KEY
        }

      return default_params if execution.used_default_params?

      default_params.merge(params_url: execution.params_file.direct_upload_url)
    end
  end
end

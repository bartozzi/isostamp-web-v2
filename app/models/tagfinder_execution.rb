class TagfinderExecution < ActiveRecord::Base
  belongs_to :user
  belongs_to :data_file,   class_name: 'Document'
  belongs_to :params_file, class_name: 'Document'

  validates_presence_of %i(user data_file)

  def status
    case success
      when nil   then 'Still running...'
      when true  then 'Success!'
      when false then 'Failure'
    end
  end

  def run
    puts '------------------------------------------'.black
    puts 'Ignoring params file for now!!'.red
    # doc_url = Document.find(data_file_id).attachment.url
    # filepath = "./tmp/#{Time.now.utc.to_i}-#{File.basename(doc_url)}"

    # stdin, stdout, stderr = Open3.popen3("wget #{doc_url} -O #{filepath};")

    build_result = ''

    # stdout.each_line { |line| print line.green; build_result << line }
    # build_result <<  "\n------------------------------------------\n"
    # stderr.each_line { |line| print line.red;   build_result << line }
    # build_result <<  "\n------------------------------------------\n"

    stdin, stdout, stderr = Open3.popen3("#{executable}")# #{filepath};")
    build_result <<  "\n------------------------------------------\nSTDOUT:\n"
    stdout.each_line { |line| print line.green; build_result << line }
    build_result <<  "\n------------------------------------------\nSTDERR:\n"
    successful = true
    stderr.each_line do |line|
      print line.red
      build_result << line
      successful = false if !line.blank?
    end
    build_result <<  "\n------------------------------------------\n"

    update_attributes(result: build_result, success: successful)
    # stdin, stdout, stderr = Open3.popen3("rm #{filepath};")
    puts '------------------------------------------'.black
  end

  private

  def executable
    case Rails.env
      when *%w(development test)   then 'bin/tagfinder-mac'
      when *%w(staging production) then 'bin/tagfinder'
    end
  end
end

class IO
  ## result_array to file
  def self.to_file(result_array, filename)
    file = File::open(filename, 'w')
    result_array.each do |val|
      file.puts val
    end
    file.close
  end

end

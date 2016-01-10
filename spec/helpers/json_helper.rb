module JsonHelper
  def format_json(dir, file)
    JSON.parse(File.read(File.join(Rails.root, 'spec', 'static_data', dir, file)))
  end

  def format_json_string(dir, file)
    JSON.parse(File.read(File.join(Rails.root, 'spec', 'static_data', dir, file))).to_json
  end
end

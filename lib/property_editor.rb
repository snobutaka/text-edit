require_relative 'text_editor'

class PropertyEditor
  def initialize(file_path)
    @editor = TextEditor.new(file_path)
  end

  def get(key)
    linum = @editor.find_line(key_value_pattern(key))
    return nil unless linum
    line = @editor.read_line(linum)
    line.scan(key_value_pattern(key)) do |matches|
      raise unless matches.size() == 1
      return matches.fetch(0).strip()
    end
  end

  def set(key, value)
    linum = @editor.find_line(key_value_pattern(key))
    if linum
      modify_value(linum, key, value)
    else
      append_value(key, value)
    end
  end

  def delete(key)
    linum = @editor.find_line(key_value_pattern(key))
    return unless linum
    @editor.delete_line(linum)
  end

  private

  def modify_value(linum, key, value)
    @editor.delete_line(linum)
    @editor.insert_line(linum, key_value_entry(key, value))
  end

  def append_value(key, value)
    @editor.append_line(key_value_entry(key, value))
  end

  def key_value_pattern(key)
    /^\s*#{key}\s*=(.*)$/
  end

  def key_value_entry(key, value)
    "#{key}=#{value}"
  end
end

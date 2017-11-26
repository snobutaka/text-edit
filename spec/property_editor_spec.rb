require 'tempfile'
require 'property_editor'

describe PropertyEditor do
  it "gets property value" do
    tempfile = create_tempfile(["one=1", "two=2", "three=3"].join("\n"))
    editor = PropertyEditor.new(tempfile)
    expect(editor.get("one")).to eq "1"
    expect(editor.get("two")).to eq "2"
    expect(editor.get("three")).to eq "3"
    expect(editor.get("four")).to eq nil
  end
end

describe PropertyEditor do
  it "adds property value" do
    tempfile = create_tempfile(["one=1", "two=2"].join("\n"))
    editor = PropertyEditor.new(tempfile)
    editor.set("three", "3")
    expect(File.read(tempfile)).to eq ["one=1", "two=2", "three=3"].join("\n") + "\n"
  end
end

describe PropertyEditor do
  it "changes property value" do
    tempfile = create_tempfile(["one=1", "two=2", "three=3"].join("\n"))
    editor = PropertyEditor.new(tempfile)
    editor.set("two", "0x10")
    expect(File.read(tempfile)).to eq ["one=1", "two=0x10", "three=3"].join("\n") + "\n"
  end
end

describe PropertyEditor do
  it "deletes property value" do
    tempfile = create_tempfile(["one=1", "two=2", "three=3"].join("\n"))
    editor = PropertyEditor.new(tempfile)
    editor.delete("two")
    expect(File.read(tempfile)).to eq ["one=1", "three=3"].join("\n") + "\n"
  end
end

def create_tempfile(content)
  tempfile = Tempfile.new(self.class().name())
  File.write(tempfile, content)
  tempfile
end

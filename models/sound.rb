class Sound
  include Mongoid::Document
  field :hex_id, :type => String, :default => ''
  field :user, :type => String, :default => @@conf['default_name']
  field :uploaded_at, :type => Integer, :default => 0
  field :file_type, :type => String, :default => ''
  field :mime_type, :type => String, :default => ''
  field :length, :type => Float, :default => 0
  def file
    "#{hex_id}.#{file_type}"
  end

  def to_hash
    {
      :hex_id => hex_id,
      :user => user,
      :uploaded_at => uploaded_at,
      :file => file,
      :file_type => file_type,
      :mime_type => mime_type,
      :length => length
    }
  end
end

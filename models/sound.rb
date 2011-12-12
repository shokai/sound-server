class Sound
  include Mongoid::Document
  field :hex_id, :type => String, :default => ''
  field :user, :type => String, :default => @@conf['default_name']
  field :uploaded_at, :type => Integer, :default => 0
  field :file, :type => String, :default => ''
  field :file_type, :type => String, :default => ''
  field :mime_type, :type => String, :default => ''
  field :length, :type => Float, :default => 0
  def to_hash
    {
      :hex_id => hex_id,
      :uploaded_at => uploaded_at,
      :mime_type => mime_type,
    }
  end
end

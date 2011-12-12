begin
  @@igo = Igo::Tagger.new(File.dirname(__FILE__)+'/../ipadic')
rescue => e
  STDERR.puts 'mecab error'
  STDERR.puts e
  exit 1
end

class String
  def to_kana
    begin
      return @@igo.parse(self.strip).map{|i|
        kana = i.feature.split(',')[-2].to_s
        kana = i.surface.to_s if kana == nil or kana == '*'
        kana
      }.join('').strip
    rescue => e
      STDERR.puts e
      return ''
    end
  end
end

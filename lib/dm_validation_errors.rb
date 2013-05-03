module DataMapper
  module Validations
    class ValidationErrors
      def to_html
        haml = <<EOS
%ul
  -item.each do |error|
    -error.each do |message|
      %li=message
EOS

        Haml::Engine.new(haml).render(self, :item=>self)
      end
    end
  end
end

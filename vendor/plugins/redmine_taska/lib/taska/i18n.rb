module I18n
  module Backend
    class Simple    
      def pluralize(locale, entry, count)
        return entry unless entry.is_a?(Hash) and count
        unless locale == :ru
          key = :zero if count == 0 && entry.has_key?(:zero)
          key ||= count == 1 ? :one : :other
        else
          key = :zero if count == 0 && entry.has_key?(:zero)
          if key.nil? && count >= 11 && count <= 19
            key = :many
          elsif key.nil?
            key ||= case count % 10
              when 0 then :few
              when 1 then :one
              when 2..4 then :few
              when 5..9 then :many
            end
          end
        end
        key = :other unless entry.has_key?(key)
        raise InvalidPluralizationData.new(entry, count) unless entry.has_key?(key)
        entry[key]
      end
    end
  end
end
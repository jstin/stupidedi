module Stupidedi
  module Values

    class TableVal < AbstractVal
      include SegmentValGroup

      # @return [TableDef]
      attr_reader :definition

      # @return [Array<SegmentVal>]
      attr_reader :header_segment_vals

      # @return [Array<SegmentVal>]
      attr_reader :trailer_segment_vals

      # @return [Array<LoopVal>]
      attr_reader :loop_vals

      # @return [TransactionSetVal]
      attr_reader :parent

      def initialize(definition, header_segment_vals, loop_vals, trailer_segment_vals, parent)
        @definition, @header_segment_vals, @loop_vals, @trailer_segment_vals, @parent =
          definition, header_segment_vals, loop_vals, trailer_segment_vals, parent
      end

      # @return [TableVal]
      def copy(changes = {})
        self.class.new \
          changes.fetch(:definition, @definition),
          changes.fetch(:header_segment_vals, @header_segment_vals),
          changes.fetch(:loop_vals, @loop_vals),
          changes.fetch(:trailer_segment_vals, @trailer_segment_vals),
          changes.fetch(:parent, @parent)
      end

      # @return [Array<SegmentVal>]
      def segment_vals
        @header_segment_vals + @trailer_segment_vals
      end

      # @return [TableVal]
      def append_header(segment_val)
        copy(:header_segment_vals => segment_val.snoc(@header_segment_vals))
      end

      # @return [TableVal]
      def append_trailer(segment_val)
        copy(:trailer_segment_vals => segment_val.snoc(@trailer_segment_vals))
      end

      # @return [TableVal]
      def append_loop(loop_val)
        copy(:loop_vals => loop_val.snoc(@loop_vals))
      end

      # @private
      def pretty_print(q)
        id = @definition.try{|t| "[#{t.id}]" }
        q.text("TableVal#{id}")
        q.group(2, "(", ")") do
          q.breakable ""
          @header_segment_vals.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @loop_vals.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
          @trailer_segment_vals.each do |e|
            unless q.current_group.first?
              q.text ","
              q.breakable
            end
            q.pp e
          end
        end
      end

      # @private
      def ==(other)
        other.definition           == @definition and
        other.header_segment_vals  == @header_segment_vals and
        other.trailer_segment_vals == @trailer_segment_vals and
        other.loop_vals            == @loop_vals
      end
    end

  end
end

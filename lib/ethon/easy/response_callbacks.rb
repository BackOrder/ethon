module Ethon
  class Easy

    # This module contains the logic for the response callbacks.
    # The on_complete callback is the only one at the moment.
    #
    # You can set multiple callbacks, which are then executed
    # in the same order.
    #
    #   easy.on_complete { p 1 }
    #   easy.on_complete { p 2 }
    #   easy.complete
    #   #=> 1
    #   #=> 2
    #
    # You can clear the callbacks:
    #
    #   easy.on_complete { p 1 }
    #   easy.on_complete { p 2 }
    #   easy.on_complete.clear
    #   easy.on_complete
    #   #=> []
    module ResponseCallbacks

      # Set on_headers callback.
      #
      # @example Set on_headers.
      #   request.on_headers { p "yay" }
      #
      # @param [ Block ] block The block to execute.
      def on_headers(&block)
        @on_headers ||= []
        @on_headers << block if block_given?
        @on_headers
      end

      # Execute on_headers callbacks.
      #
      # @example Execute on_headers.
      #   request.headers
      def headers
        return if @headers_called
        @headers_called = true
        if defined?(@on_headers) and not @on_headers.nil?
          @on_headers.each{ |callback| callback.call(self) }
        end
      end

      # Set on_complete callback.
      #
      # @example Set on_complete.
      #   request.on_complete { p "yay" }
      #
      # @param [ Block ] block The block to execute.
      def on_complete(&block)
        @on_complete ||= []
        @on_complete << block if block_given?
        @on_complete
      end

      # Execute on_complete callbacks.
      #
      # @example Execute on_completes.
      #   request.complete
      def complete
        headers unless @response_headers.empty?
        if defined?(@on_complete) and not @on_complete.nil?
          @on_complete.each{ |callback| callback.call(self) }
        end
      end

      # Set on_body callback.
      #
      # @example Set on_body.
      #   request.on_body { |chunk| p "yay" }
      #
      # @param [ Block ] block The block to execute.
      def on_body(&block)
        @on_body ||= []
        @on_body << block if block_given?
        @on_body
      end

      # Execute on_body callbacks.
      #
      # @example Execute on_body.
      #   request.body("This data came from HTTP.")
      #
      # @return [ Object ] If there are no on_body callbacks, returns the symbol :unyielded.
      def body(chunk)
        if defined?(@on_body) and not @on_body.nil?
          result = nil
          @on_body.each do |callback|
            result = callback.call(chunk, self)
            break if result == :abort
          end
          result
        else
          :unyielded
        end
      end
    
      def on_progress(&block)
         puts "Ethon>>response_callback.rb: on_progress (block_given? #{block_given?})"
        @on_progress ||= []
        @on_progress << block if block_given?
        @on_progress
      end
    end
  end
end

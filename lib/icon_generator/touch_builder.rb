module IconGenerator
    class TouchBuilder
        include IconGenerator::Validator

        # Initializes the default image sizes.
        def initialize
            @apple_sizes = [
                '180x180',
                '167x167',
                '152x152',
                '144x144',
                '120x120',
                '114x114',
                '76x76',
                '72x72',
                '57x57',
            ]
            @chrome_sizes = [
                '144x144',
                '192x192',
                '96x96',
                '72x72',
                '48x48',
                '36x36',
            ]
            @microsoft_sizes = [
                '310x310',
                '310x150',
                '150x150',
                '144x144',
                '70x70',
            ]
        end

        # Builds apple-touch-icons from the given source file.
        #
        # @param source [String] the source image file
        # @param destination [String] the output directory
        def build(source, destination)
            @apple_sizes.each do |size|                   
                if size == '180x180'
                    build_size(source, '180x180', "#{destination}/apple-touch-icon.png")                    
                    build_size(source, '180x180', "#{destination}/apple-touch-icon-precomposed.png")
                else
                    # Create precomposed icons
                    new_precomposed_image = "#{destination}/apple-touch-icon-#{size}-precomposed.png"
                    build_size(source, size, new_precomposed_image)
                    # Create normal icons
                    new_image = "#{destination}/apple-touch-icon-#{size}.png"
                    build_size(source, size, new_image)                    
                end
            end
            @chrome_sizes.each do |size|
                new_image = "#{destination}/touch-icon-#{size}.png"
                build_size(source, size, new_image)
            end
            @microsoft_sizes.each do |size|
                new_image = "#{destination}/mstile-#{size}.png"
                build_size(source, size, new_image)
            end
        end

        # Builds a single 152x152 apple-touch-icon-precomposed from the
        # given source file.
        #
        # @param source [String] the source image file
        # @param destination [String] the output directory
        def build_single(source, destination)
            build_size(source, '180x180', "#{destination}/apple-touch-icon.png")
            build_size(source, '180x180', "#{destination}/apple-touch-icon-precomposed.png")
        end

        # Builds a given size of apple-touch-icon.
        #
        # @param source [String] the source image file
        # @param size [String] the requested image size, in WxH format
        # @param new_image [String] the output image
        def build_size(source, size, new_image)
            %x[convert '#{source}' -resize #{size}! #{new_image}]
            validate_file_status new_image
            puts Thor::Shell::Color.new.set_color("Built #{new_image}", :green)
        end
    end
end

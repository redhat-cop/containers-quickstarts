=begin
    Copyright 2010-2017 Sarosys LLC <http://www.sarosys.com>

    This file is part of the Arachni Framework project and is subject to
    redistribution and commercial restrictions. Please see the Arachni Framework
    web site for more information on licensing and terms of use.
=end

require 'nokogiri'

# Creates an XUnit XML report of the audit.
#
# @author Me
class Arachni::Reporters::XUNIT < Arachni::Reporter::Base

    LOCAL_SCHEMA  = File.dirname( __FILE__ ) + '/xml/hudson_junit-4.xsd'
    REMOTE_SCHEMA = 'https://raw.githubusercontent.com/Arachni/arachni/' <<
        "v#{Arachni::VERSION}/components/reporters/xml/hudson_junit-4.xsd"
    NULL          = '[ARACHNI_NULL]'

    def run
        builder = Nokogiri::XML::Builder.new do |xml|
            xml.testsuite(
                'name' => report.options[:url],
				'timestamp' => report.finish_datetime.xmlschema,
				'tests' => report.issues.count
			) {
				report.issues.each do |issue|
				xml.testcase(
					'name' => issue.name,
					'classname' => report.options[:url]
				) {
					xml.failure(
						'message' => issue.description
					)
				}
				end
            }
        end

        xml = builder.to_xml

        xsd = Nokogiri::XML::Schema( IO.read( LOCAL_SCHEMA ) )
        has_errors = false
        xsd.validate( Nokogiri::XML( xml ) ).each do |error|
            puts error.message
            puts " -- Line #{error.line}, column #{error.column}, level #{error.level}."
            puts '-' * 100

            justify = (error.line+10).to_s.size
            lines = xml.lines
            ((error.line-10)..(error.line+10)).each do |i|
                line = lines[i]
                next if i < 0 || !line
                i = i + 1

                printf( "%#{justify}s | %s", i, line )

                if i == error.line
                    printf( "%#{justify}s |", i )
                    line.size.times.each do |c|
                        print error.column == c ? '^' : '-'
                    end
                    puts
                end
            end

            puts '-' * 100
            puts

            has_errors = true
        end

        if has_errors
            print_error 'Report could not be validated against the XSD due to the above errors.'
            return
        end

        IO.binwrite( outfile, xml )

        print_status "Saved in '#{outfile}'."
    end

    def self.info
        {
            name:         'XUNIT',
            description:  %q{Exports the audit results as an XUNIT XML (.xml) file.},
            content_type: 'text/xml',
            author:       'Me',
            version:      '0.0.1',
            options:      [ Options.outfile( '-xunit.xml' )]
        }
    end
end

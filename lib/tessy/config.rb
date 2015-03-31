module Tessy
  class Config
    class << self
      def config
        {
            filename: {
                original: /^Scan/i
            },
            title: {
                reject: [
                    /evform/i,
                    /^\/$/,
                    /e-form/i
                ]
            },
            date: {
                reject: [
                    /evform/i,
                    /e-form/i,
                    /DateOfBirth/
                ],
                long_months: 'january|february|march|april|may|june|july|august|september|october|november|december',
                short_months: 'jan|feb|mar|apr|may|jun|jul|aug|sep|sept|oct|nov|dec',
                seperator: '[-\/]',
                long_year: '[12][09][0-9][0-9]',

            }
        }
      end
    end
  end
end
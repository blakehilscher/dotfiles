module Tessy
  class Config
    class << self
      def config
        {
            filename: {
                original: /^Scan/i
            },
            title: {
                accept: {
                    /Goods and Services Tax/i => 'gst',
                    /business number/i => 'business',
                    /notice of assessment/i => 'notice-of-assessment',
                    /Business Account Statement/i => 'business-account-statement'
                },
                reject: [
                    /evform/i,
                    /^\/$/,
                    /e-form/i
                ],
                page: [
                    /page (\d) of (\d)/i,
                    /(\d) of (\d)/i,
                ],
                tags: {
                    /rbc/i => 'rbc',
                    /tax return/i => 'tax',
                    /cra/i => 'tax',
                    /Canada Revenue/i => 'tax',
                    /notice of assessment/i => 'tax',
                }
            },
            date: {
                reject: [
                    /evform/i,
                    /e-form/i,
                    /DateOfBirth/,
                    /e‘form/i,
                    /11\/10\/1988/,
                    /1988\/03\/29/
                ],
                long_months: 'january|february|march|april|may|june|july|august|september|october|november|december',
                short_months: 'jan|feb|mar|apr|may|jun|jul|aug|sep|sept|oct|nov|dec',
                seperator: '[-\/]',
                long_year: '[12][0-9][0-9][0-9]',

            }
        }
      end
    end
  end
end
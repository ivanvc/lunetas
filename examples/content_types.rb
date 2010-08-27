require 'lunetas'
require 'base64'

class ContentTypes
  include Lunetas::Candy
  matches '^/test\.(\w+)', :format
  set_content_type 'text/plain'

  def get
    case @format
    when 'png'
      set_content_type 'image/png'
      Base64.decode64(DATA)
    when 'html'
      set_content_type 'text/html'
      '<center>cool <img src="/test.png" alt="test" /></center>'
    when 'txt'
      'OH HAI ;D'
    end
  end

  DATA = "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/I\nNwWK6QAAABl0RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAJa\nSURBVDjLpZNPSFVREIe/c9/r+tD36vW/IA2rTUYlZbp0FQTRQqmgXFW7loIr\na+NWCFxFENQmgsyEQnGlSIFUVIsURKuHBZmlWWnee985Z6aNaWa0qFkOwzcz\nv/mNUVX+J9K/J9yAyarSrMIxEWpVQYUnIvSpcCV3Qud/rTe/TuAGTL0KN0xF\nS6XJ16LhBlCPRtP42Rck4+0FEc6tb9DBVQDXbxo0X38v2NaElq7DL4wiyQzq\nYjAZgswejA1I3naSTA02bj6t3UsA2282qDKR2n87K8E3fFwAO4e4BPUx32YW\nePk84kBdJfktNXwdOj8vws7tTfo5AFChOdjZmtUQJCnQdfUZXdfH6L45Ab7I\n2MgCmRLP8ONxfPKa0r2tWfE0L4kowvHU+jp8PIy6iMYLu1EXoz5BbcyhGhBf\nRG2M+/KMcOsZxHMcuPQTUEXJWiT6gorlzcgmTDqHQUEVWNTJOXbk7wMJ3lO5\nNIEKkbo4xDvwRcqPnAUTrjiviqc0v525x12gigip5RU8BWxUDSEqlmy+jCBT\nsco06mNMUIr4NDbhFUCwuEKPnX6BCStQAff1EahbBbAzg6TXHiSansAW6VkG\neDoWRtrmcTmCsJzixwckk7eR4qfFzhHFqV6S991oyUEmH7bN24SOFUb6dMec\nTG8+2pmpaITUHG72KT56j7oYk86RylXj2cXsaC+zY32nDrXq3VVWnrxljorn\nWllVS2W4cR/BmgDE4RLP98kxPgy1F5zl4uFL2vfHXwB4d9NkxdMiwjHvqXVF\ncJYnztLnLO01l//yTP8SPwD79F9Uvnnx1AAAAABJRU5ErkJggg==\n"
end

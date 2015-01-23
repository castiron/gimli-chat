module.exports = class MessageFormatter

  @patternCouch: (str, pattern) ->
    out = str
    n = Math.ceil(str.length / pattern.length) + 1
    extra = str.length % pattern.length
    console.log str.length, pattern.length, n, extra
    if n > 0 and pattern.length > 0
      chain = []
      while n -= 1
        chain.push pattern
      c = chain.join('').substr 0, str.length
      out = "#{c}\n#{str}\n#{c}"
    out

  @codeBlock: (str) -> "```#{str}```"
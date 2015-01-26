module.exports = class MessageFormatter

  @patternCouch: (str, pattern) ->
    out = str
    n = Math.ceil(str.length / pattern.length) + 1
    extra = str.length % pattern.length
    if n > 0 and pattern.length > 0
      chain = []
      while n -= 1
        chain.push pattern
      c = chain.join('').substr 0, str.length
      out = "#{c}\n#{str}\n#{c}"
    out

  @codeBlock: (str) -> "```\n#{str}\n```"
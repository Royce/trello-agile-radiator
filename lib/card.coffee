class Card
	constructor: (@data, options) ->
		@text_split =
			regex: /^(?:\((.+?)\)\s+)?(?:(.+)\:\s)?(.*?)(?:\s+\((.+?)\))?$/
			size_start: 1
			prefix: 2
			name: 3
			size_end: 4
		@name_parts = @data?.name?.match(@text_split.regex)

	name: () ->
		@name_parts[@text_split.name] or @data?.name

	prefix: () ->
		@name_parts[@text_split.prefix]

	size: () ->
		@name_parts[@text_split.size_start] or
		@name_parts[@text_split.size_end]

module.exports = Card
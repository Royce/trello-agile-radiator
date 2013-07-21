_ = require "underscore"

class Card
	constructor: (@data, @options) ->
		@text_split = text_split =
			regex: /^(?:\((.+?)\)\s+)?(?:(.+)\:\s)?(.*?)(?:\s+\((.+?)\))?$/
			size_start: 1
			prefix: 2
			name: 3
			size_end: 4

		@name_parts = @data?.name?.match(@text_split.regex)

		@_labels = _.pluck @data?.labels, 'name'

		@_tasks = _.chain(@data?.checklists)
		.map (checklist) ->
			_.chain(checklist.checkItems)
			.where
				state: 'incomplete'
			.map (item) ->
				parts = item.name.match(text_split.regex)
				name: parts[text_split.name]
				size: parts[text_split.parts]
				list: checklist.name
			.value()
		.flatten()
		.value()

	name: () ->
		@name_parts[@text_split.name] or @data?.name

	prefix: () ->
		@name_parts[@text_split.prefix]

	size: () ->
		@name_parts[@text_split.size_start] or
		@name_parts[@text_split.size_end]

	labels: () -> @_labels

	remainingTasks: () -> @_tasks

	listName: () ->
		if @options?.listLookup
			@options.listLookup[@data.idList]
		else
		  throw 'Need a list lookup to find the list name'


module.exports = Card
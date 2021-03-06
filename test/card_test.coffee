Card = require("../lib/card")

module.exports =
	'there is a card': ->
		new Card({})

	'knows about name': ->
		c = new Card
			name: 'name' 
		c.name().should.eql 'name'

	'pulls prefix from name': ->
		c = new Card {name: 'prefix: the name'}
		c.prefix().should.eql 'prefix'
		c.name().should.eql 'the name'

	'pulls size from end of name': ->
		c = new Card {name: 'the name (3)'}
		c.size().should.eql '3'
		c.name().should.eql 'the name'

	'pulls size from start of name': ->
		c = new Card {name: '(Tr) the name'}
		c.size().should.eql 'Tr'
		c.name().should.eql 'the name'

	'flattens labels': ->
		c = new Card
			labels: [
				color: 'red'
				name: 'One'
			,
				color: 'blue'
				name: 'Two' 
			]
		c.labels()
		.should.be.an.instanceOf(Array)
		.and.have.length(2)
		.and.include('One')
		.and.include('Two')

	'flattens and extracts size from checklist': ->
		c = new Card
			checklists: [
				name: 'Dev. tasks'
				checkItems: [
					state: 'incomplete'
					name: '(2h) dev one'
				,
					state: 'complete'
					name: '(2h) dev one'
				]
			,
				name: 'Acceptance Criteria'
				checkItems: [
					state: 'incomplete'
					name: 'Test the thing'
				]
			]
		c.remainingTasks()
		.should.be.an.instanceOf(Array)
		.and.have.length(2)
		#.and.include('One')
		#.and.include('Two')

	'translate list ids': ->
		data =
			idList: 'f76'
		config =
			listLookup:
				f76: 'To Do'
		
		c = new Card data, config
		c.listName().should.eql('To Do')

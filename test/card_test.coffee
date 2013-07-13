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

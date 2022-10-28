import 'imba/preflight.css'

tag app
	prop key = ""
	prop value = ""
	css .logo h:6em p:1.5em
	<self>
		<app-controls>

tag app-controls
	prop num = ""
	def mount
		getAll!
	def getAll
		let response = await window.fetch "/all"
		let data = await response.json()
		num = data.number
		console.log "loaded {data.number} from json"
		imba.commit!
	
	def addWord val
		# # Increment the counter on the server, then update the client
		try
			const response = await window.fetch("/add/{val}", {
				method: 'POST'
				headers: {'Content-Type': 'application/json'}
				body: JSON.stringify({"num":"{num}"})
			})
			const data = await response.json()
			console.log "saved {data.num} to json"
		catch e
			console.error "couldn't save number"
		num = ""
		imba.commit!
	css self d:box min-height:100vh bg:gray9
		button c:white py:1em rd:6px
			bg:gray7 @hover:gray6 @click:gray8
			@html.dark
			@body.dark
			@div.active
	<self>
		<div.card[d:vflex g:1em]>
			<div><input bind=num>
			<button @click.addWord("{num}")> "Save {num}"
			<button @click.getAll> "Load"

imba.mount <app>, document.getElementById('app')

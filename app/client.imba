global.LOG = console.log
import 'imba/preflight.css'

# keep copy of json in localstorage
let local = imba.locals('20230617-fsjson-project')

let state = {
	"words": [
		"hello"
		"world"
	]
}

# mutate data in local storage
# make save button that saves to json
# make load button that loads json to local storage
tag app
	prop key = ""
	prop value = ""
	css .logo h:6em p:1.5em
	<self>
		<app-controls>

tag app-controls
	prop num = 0
	
	def saveLocal
		local.state = state
		console.log 'localstorage state', local.state
	def loadLocal
		if local.state
			state = local.state
			# console.log 'app state', state
			return state
		else
			console.log 'no local state'
			return false
		
	def saveJson
		let data = loadLocal!
		# console.log data
		try
			const res = await window.fetch("/save", {
				method: 'POST'
				headers: {'Content-Type': 'application/json'}
				body: JSON.stringify(data)
			})
			console.log await res.json()
			console.log "saved data to json", res
		catch e
			console.error "couldn't save number"
	def loadJson
		try
			const response = await window.fetch "/load"
			const data = await response.json()
			console.log "loaded data from json"
			console.log data
			state = data
			imba.commit!
		catch e
			console.error "couldn't load number"
		
	# def mount
	# 	getNumber!
	def getNumber
		try
			const response = await window.fetch "/number"
			const data = await response.json()
			num = data.number
			console.log "loaded {num} from json"
			imba.commit!
		catch e
			console.error "couldn't load number"
		
	# def getAll
	# 	let response = await window.fetch "/all"
	# 	let data = await response.json()
	# 	num = data.number
	# 	console.log "loaded {num} from json"
	# 	imba.commit!

	def addNumber num
		try
			const res = await window.fetch("/add/{num}", {
				method: 'POST'
				headers: {'Content-Type': 'application/json'}
				body: JSON.stringify({"num":"{num}"})
			})
			const data = await res.json()
			console.log "saved {data.num} to json"
		catch e
			console.error "couldn't save number"
	# def addWord val
	# 	# # Increment the counter on the server, then update the client
	# 	try
	# 		const response = await window.fetch("/add/{val}", {
	# 			method: 'POST'
	# 			headers: {'Content-Type': 'application/json'}
	# 			body: JSON.stringify({"num":"{num}"})
	# 		})
	# 		const data = await response.json()
	# 		console.log "saved {data.num} to json"
	# 	catch e
	# 		console.error "couldn't save number"
	# 	# num = data
	# 	imba.commit!
	# def test
	# 	LOG "test"
	# 	try
	# 		const res = await window.fetch("/setplayer", {
	# 			method: 'POST'
	# 			headers: {'Content-Type': 'application/json'}
	# 			body: JSON.stringify({"key":"value"})
	# 		})
	<self>
		<div.card[d:vflex g:1em]>
			<div>
				<input bind=num>
			# <> console.warn num
			<button @click.addNumber(num)>
				"Save {num}"
			<button @click.test>
				"test"
			<button @click.loadLocal> "load"
			<button @click.saveLocal> "save"
			<button @click.saveLocal> "save"
			<button[bg:red4] @click.saveJson> "saveJSON"
			<button[bg:green4] @click.loadJson> "loadJSON"

	css self d:box min-height:100vh bg:gray9
		button c:white py:1em rd:6px
			bg:gray7 @hover:gray6 @click:gray8
			@html.dark
			@body.dark
			@div.active

imba.mount <app>

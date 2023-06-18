global.LOG = console.log
import fs from 'fs'
import express from 'express'
import index from './app/index.html'
import {FSDB} from 'file-system-db' # readme: https://www.npmjs.com/package/file-system-db
const db = new FSDB('./db.json', false)
let data = fs.readFileSync('./dictionary.json')
let words = JSON.parse(data)
# LOG words

# db.set("player", "bob")
# db.get("player")
# db.getAll!
# db.startsWith('keyname')
# db.has('keyname')
# db.delete('keyname')
# db.deleteAll!
# db.push("keyofarray", "data to push")
# db.push("keyofarray", ["data", "to", "push"])
# db.pull("keyofarray", "data to remove")
# db.pull("keyofarray", ["data", "to", "remove"])
# db.add("coins", 100)
# db.subtract("coins", 100)
# db.multiply("coins", 2)
# db.divide("coins", 4)


# Using Imba with Express as the server is quick to set up:
const app = express()
const port = process.env.PORT or 3000


# Express works like usual, so we can allow JSON in the POST request:
const jsonBody = express.json({ limit: '50mb' })
	
app.post('/save', jsonBody) do(req,res)
	db.set "state", req.body
	console.log "state", req.body

# gets data from db.json
app.get('/load') do(res,req)
	req.send db.getAll!
	console.log "loaded {db.number}"

# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)
	res.send(index.body)

# Express is set up and ready to go!
imba.serve(app.listen(port))

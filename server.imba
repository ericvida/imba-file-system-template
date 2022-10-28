import fs from 'fs-extra'
import express from 'express'
import index from './app/index.html'


# Using Imba with Express as the server is quick to set up:
const app = express()
const port = process.env.PORT or 3000


# Express works like usual, so we can allow JSON in the POST request:
const jsonBody = express.json({ limit: '1kb' })

let db = JSON.parse fs.readFileSync './db.json'

app.post('/add/:num', jsonBody) do(req,res)
	let num = req.params.num
	let reply
	db["number"] = num
	let data = JSON.stringify db, null, 2
	try 
		await fs.writeFile('db.json', data)
		reply = {
			num: num
			status: "success"
		}
		res.send reply
		console.log 'saved ' + num
	catch err
		console.log err
	reply = {
		msg: "thank you for your number: {num}"
	}

# gets data from db.json
app.get('/all') do(res,req)
	req.send db
	console.log "loaded {db.number}"

# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)

	res.send(index.body)

# Express is set up and ready to go!
imba.serve(app.listen(port))

const info  = require('./package.json')
const micro = require('micro')

const app = async (req, res) => {
  micro.send(res, 200, info)
}

const server = micro(app)

module.exports = { server, app }

#!/usr/bin/env node
require('dotenv').config()
const { server } = require('..')
const PORT = process.env.PORT || 80
server.listen(PORT, () => console.log(`Server running at PORT ${PORT}`))
// shut down server
const shutdown = () => {
  server.close(function onServerClosed (err) {
    if (err) {
      console.error(err)
      process.exitCode = 1
    }
    process.exit()
  })
}
process.on('SIGINT', function onSigint () {
  console.info('Got SIGINT (aka ctrl-c in docker). Graceful shutdown ', new Date().toISOString())
  shutdown()
})
// quit properly on docker stop
process.on('SIGTERM', function onSigterm () {
  console.info('Got SIGTERM (docker container stop). Graceful shutdown ', new Date().toISOString())
  shutdown();
})


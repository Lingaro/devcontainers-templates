// Project plugins

// Provides BuildInfoPlugin which generates build information
addSbtPlugin("com.eed3si9n" % "sbt-buildinfo" % "0.10.0")

// scoverage for test coverage settings used in build.sbt
addSbtPlugin("org.scoverage" % "sbt-scoverage" % "2.1.1")

// assembly plugin for creating fat jars and merge strategy constants
addSbtPlugin("com.eed3si9n" % "sbt-assembly" % "1.2.0")

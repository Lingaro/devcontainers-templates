// build.sbt
import sbt._
import sbt.Keys._

name := "PG-Samanta-ETL"

// after update, please rebuild with sbt
version := "1.0.168"

scalaVersion := "2.12.20"
val sparkVersion = "3.5.2"

lazy val idePackagePrefix = settingKey[Option[String]]("Package prefix for IDE")
idePackagePrefix := Some("com.pg.samanta")
Global / excludeLintKeys += idePackagePrefix

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "3.2.17" % Test, // Unit tests
  "org.apache.spark" %% "spark-core" % sparkVersion % "provided", // Spark
  "org.apache.spark" %% "spark-sql" % sparkVersion % "provided", // Spark SQL
  // "com.mysql" % "mysql-connector-j" % "8.1.0", // MySQL JDBC
  "org.mariadb.jdbc" % "mariadb-java-client" % "3.3.2" % "provided", // MariaDB JDBC
  "com.lihaoyi" %% "upickle" % "3.1.3", // JSON support
  "com.github.servicenow.stl4j" % "stl-decomp-4j" % "1.0.5", // Forecast
  "com.lihaoyi" %% "fastparse" % "3.0.2", // Parser building tool
  "org.yaml" % "snakeyaml" % "1.33", // For moultingyaml, we use version 1.33 from Databricks Runtime 13.3 LTS
  "org.scala-lang" % "scala-reflect" % scalaVersion.value, // For moultingyaml
  "com.github.nscala-time" %% "nscala-time" % "2.32.0", // For moultingyaml
  "org.apache.poi" % "poi-ooxml" % "5.2.3"// required to produce Excel file for Walmart
)

dependencyOverrides ++= Seq(
  "org.apache.commons" % "commons-math3" % "3.6.1"
)

scalacOptions ++= Seq(
  "-language:postfixOps",
  "-feature" // to check -feature interactively in sbt: set ThisBuild / scalacOptions ++= Seq("-feature")
)

// force full test coverage
// as coverage-off is disabled, some stats have been lowered for the files which should be not covered
coverageFailOnMinimum := false
coverageMinimumStmtTotal := 80
coverageMinimumBranchTotal := 80
coverageMinimumStmtPerPackage := 0
coverageMinimumBranchPerPackage := 0
coverageMinimumStmtPerFile := 0
coverageMinimumBranchPerFile := 0

// for code quality report
// ThisBuild / scapegoatVersion := "3.1.8"

// for printing application version
lazy val root = (project in file(".")).enablePlugins(BuildInfoPlugin)
  .settings(
    buildInfoKeys := Seq[BuildInfoKey](name, version, scalaVersion, sbtVersion),
    buildInfoPackage := "version",
    buildInfoObject := "ApplicationInfo",
    buildInfoOptions += BuildInfoOption.BuildTime
  )

ThisBuild / assemblyMergeStrategy := {
  case PathList("META-INF", _*) => MergeStrategy.discard
  case _                        => MergeStrategy.first
}

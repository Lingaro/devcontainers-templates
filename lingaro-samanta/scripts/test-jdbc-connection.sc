// Test JDBC connection to MariaDB from Spark (script)
// Run with: spark-shell -i scripts/test-jdbc-connection.sc

import org.apache.spark.sql.SparkSession

val spark = SparkSession.builder()
  .appName("JDBC Connection Test")
  .master("local[*]")
  .getOrCreate()

// Connection properties - use separate user/password options to avoid URL encoding issues
val jdbcUrl = sys.env.getOrElse("DB_URL", "jdbc:mariadb://mariadb:3306/sam")
val jdbcUser = sys.env.getOrElse("DB_USER", "sam")
val jdbcPassword = sys.env.getOrElse("DB_PASSWORD", "sampass")

println(s"Testing JDBC connection to: $jdbcUrl")

try {
  // Test basic connection with a simple query
  val df = spark.read
    .format("jdbc")
    .option("url", jdbcUrl)
    .option("user", jdbcUser)
    .option("password", jdbcPassword)
    .option("query", "SELECT VERSION() as version, DATABASE() as db, USER() as user, CAST(NOW() AS CHAR) as timestamp")
    .load()
  
  println("\n✅ JDBC Connection successful!")
  println("\nConnection details:")
  df.show(false)
  
  // Test listing tables via information_schema to avoid driver-specific SHOW wrapping
  val dbName = sys.env.getOrElse("MYSQL_DATABASE", sys.env.getOrElse("DB_NAME", "sam"))
  val tablesQuery = s"SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM information_schema.tables WHERE TABLE_SCHEMA = '$dbName'"
  val tables = spark.read
    .format("jdbc")
    .option("url", jdbcUrl)
    .option("user", jdbcUser)
    .option("password", jdbcPassword)
    .option("query", tablesQuery)
    .load()
  
  println("\nTables in database:")
  tables.show(false)
  
  println("\n✅ All JDBC tests passed!")
  
} catch {
  case e: Exception =>
    println(s"\n❌ JDBC Connection failed: ${e.getMessage}")
    e.printStackTrace()
} finally {
  spark.stop()
}

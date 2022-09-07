variable "name" {
  type        = string
  description = "Name of the automated job"
}

variable "external_stage" {
  type        = string
  description = "The external stage the file will be exported to"
}

variable "export_filename" {
  type        = string
  description = "The data export's filename including extension, e.g data.csv"
}

variable "database" {
  type        = string
  description = "The Snowflake database the task will be created in"
}

variable "schema" {
  type        = string
  description = "The Snowflake schema the task will be created in"
}

variable "table" {
  type        = string
  description = "The table or view to SELECT data from"
}

variable "columns" {
  type        = string
  description = "The columns to select from; if selecting all, use '*'"
  default     = "*"
}

variable "group_by_and_having_statement" {
  type        = string
  description = "Include any aggregate group by and having statement e.g. WHERE, LIMIT"
  default     = ""
}

variable "file_format" {
  type        = string
  description = "The file format and any additional parameters of the data export"
  default     = "(type=CSV COMPRESSION = None EMPTY_FIELD_AS_NULL=false)"
}

variable "copy_parameters" {
  description = "Any optional arguments for a COPY INTO statement"
  default     = "SINGLE = true OVERWRITE = true HEADER = true"
}

variable "session_parameters" {
  type        = map(any)
  description = "Snowflake session paramaeters"
  default     = { "TIMEZONE" = "Europe/London" }
}

variable "schedule" {
  type        = string
  description = "The schedule for the Task to run on, e.g. CRON format"
}

variable "warehouse" {
  description = "The Snowflake warehouse used to run the Task"
}

variable "enabled" {
  type        = bool
  description = "Flag to set the task to active or inactive"
  default     = true
}

variable "comment" {
  description = "Context for the Task"
}

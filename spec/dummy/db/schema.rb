# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(version: 20120823143315) do

  create_table "atrium_browse_levels", force: true do |t|
    t.integer  "atrium_exhibit_id",    null: false
    t.integer  "level_number",         null: false
    t.string   "filter_query_params"
    t.string   "solr_facet_name"
    t.string   "label"
    t.string   "exclude_query_params"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "atrium_browse_levels", ["atrium_exhibit_id"], name: "index_atrium_browse_levels_on_atrium_exhibit_id"

  create_table "atrium_collections", force: true do |t|
    t.string   "title"
    t.string   "url_slug"
    t.string   "filter_query_params"
    t.string   "theme"
    t.text     "title_markup"
    t.text     "collection_description"
    t.text     "search_instructions"
    t.text     "collection_items"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "atrium_collections", ["title"], name: "index_atrium_collections_on_title", unique: true
  add_index "atrium_collections", ["url_slug"], name: "index_atrium_collections_on_url_slug", unique: true

  create_table "atrium_descriptions", force: true do |t|
    t.integer  "atrium_showcase_id",  null: false
    t.string   "page_display"
    t.string   "title"
    t.string   "description_solr_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "atrium_descriptions", ["atrium_showcase_id", "description_solr_id"], name: "index_atrium_descriptions_showcase_and_solr_id"
  add_index "atrium_descriptions", ["atrium_showcase_id"], name: "index_atrium_descriptions_on_atrium_showcase_id"
  add_index "atrium_descriptions", ["description_solr_id"], name: "index_atrium_descriptions_on_description_solr_id"

  create_table "atrium_essays", force: true do |t|
    t.integer  "atrium_description_id", null: false
    t.string   "content_type"
    t.text     "content"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "atrium_essays", ["atrium_description_id", "content_type"], name: "index_atrium_essays_on_atrium_description_id_and_content_type"
  add_index "atrium_essays", ["atrium_description_id"], name: "index_atrium_essays_on_atrium_description_id"
  add_index "atrium_essays", ["content_type"], name: "index_atrium_essays_on_content_type"

  create_table "atrium_exhibits", force: true do |t|
    t.integer  "atrium_collection_id", null: false
    t.integer  "set_number",           null: false
    t.string   "label"
    t.string   "filter_query_params"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "atrium_exhibits", ["atrium_collection_id"], name: "index_atrium_exhibits_on_atrium_collection_id"

  create_table "atrium_search_facets", force: true do |t|
    t.integer  "atrium_collection_id", null: false
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "atrium_search_facets", ["atrium_collection_id"], name: "index_atrium_search_facets_on_atrium_collection_id"

  create_table "atrium_showcase_facet_selections", force: true do |t|
    t.integer  "atrium_showcase_id"
    t.string   "solr_facet_name"
    t.string   "value"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "atrium_showcase_facet_selections", ["atrium_showcase_id"], name: "atrium_facet_showcase_index"

  create_table "atrium_showcases", force: true do |t|
    t.text     "showcase_items"
    t.integer  "showcases_id"
    t.string   "showcases_type"
    t.string   "tag"
    t.integer  "sequence"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "atrium_showcases", ["showcases_type", "showcases_id"], name: "index_atrium_showcases_on_showcases_type_and_showcases_id"

end

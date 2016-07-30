-- Table schema tests

BEGIN;
    SELECT plan(21);
    SELECT has_table('writing');
    SELECT has_table('articles');
    SELECT has_table('reviews');
    SELECT has_table('authors');
    SELECT has_table('books');
    SELECT has_table('readings');
    SELECT has_table('intros');

    -- Issues should be going away
    SELECT hasnt_table('issue');
    SELECT hasnt_table('key_value');
    SELECT hasnt_table('template');
    SELECT hasnt_table('image');

    SELECT has_column('writing', 'title');
    SELECT has_column('writing', 'text');
    SELECT has_column('writing', 'hidden');
    SELECT col_type_is('writing', 'hidden', 'boolean');
    SELECT has_column('writing', 'publish_date', 'writing table should have a publish_date column');
    SELECT col_type_is('writing', 'publish_date', 'timestamp with time zone', 'publish_date should be a DateTime with timezone');
    SELECT is_empty('SELECT * FROM WRITING WHERE publish_date IS NULL;', 'writing publish_date should not be null for existing articles');

    -- Tags
    SELECT col_is_unique('tags', 'name', 'tags.name should be unique');

    -- writing.slug
    SELECT has_column('writing', 'slug');
    SELECT col_type_is('writing', 'slug', 'character varying(250)');

    SELECT * from finish();
ROLLBACK;

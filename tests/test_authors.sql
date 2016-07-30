
BEGIN;
    SELECT plan(2);

    SELECT has_column('authors', 'bio', 'author table should have col bio');
    SELECT is_empty('SELECT * from authors where bio is null;', 'author bios should not be null even if there is not a NOT NULL constraint');

    SELECT * from finish();
ROLLBACK;

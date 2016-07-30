-- Test changes to isbn column
-- Revision ID: 2d2fd2398328

BEGIN;
    --- booksS
    SELECT plan(10);

    SELECT has_column('books', 'edition', 'books should have col edition');
    SELECT has_column('books', 'editors', 'books should have col editors');
    SELECT has_column('books', 'translator', 'books should have col translator');

    SELECT is_empty('SELECT * FROM books WHERE isbn_10 IS NULL;', 'No existing books review should have a null isbn_10');
    SELECT col_type_is('books', 'isbn_10', 'character varying(10)', 'books isbn_10 should be var_char not integer, so that leading zeros are not truncated');
    SELECT col_type_is('books', 'isbn_13', 'character varying(13)', 'books isbn_10 should be var_char not integer, so that leading zeros are not truncated');
    SELECT is_empty('SELECT * from books where length(isbn_13) != 13', 'isbn_13 should be 13 characters long');
    SELECT is_empty('SELECT * from books where length(isbn_10) != 10', 'isbn_10 should be 10 characters long');
    SELECT col_has_check('books', 'isbn_10', 'books col isbn_10 should have a check constraint of 10 chars');
    SELECT col_has_check('books', 'isbn_13', 'books column isbn_13 should have a check constraint of 13 chars');

    SELECT * from finish();
ROLLBACK;

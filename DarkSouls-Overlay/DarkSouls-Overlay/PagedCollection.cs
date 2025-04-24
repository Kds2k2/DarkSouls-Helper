namespace DarkSouls_Overlay 
{
    public class PagedCollection<T>
    {
        private readonly List<T> _items;
        private int _currentPage;
        private readonly int _itemsPerPage;

        public PagedCollection(IEnumerable<T> items, int itemsPerPage)
        {
            _items = items.ToList();
            _itemsPerPage = itemsPerPage;
            _currentPage = 0;
        }

        public IEnumerable<T> GetCurrentPage()
        {
            return _items.Skip(_currentPage * _itemsPerPage).Take(_itemsPerPage);
        }

        public int CurrentPage => _currentPage + 1;
        public int TotalPages => (int)Math.Ceiling((double)_items.Count / _itemsPerPage);

        public bool MoveToPage(int page)
        {
            if (page < 0 || page >= TotalPages) return false;
            _currentPage = page;
            return true;
        }
    }
}

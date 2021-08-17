<?php 
namespace Erbilen\Database; 

class BasicDB extends \PDO 
{ 

    /** 
     * Built SQL Query 
     * 
     * @var 
     * 
     */ 
    private $sql; 

    /** 
     * Table Name 
     * 
     * @var 
     * 
     */ 
    private $tableName; 

    /** 
     * Condittions 
     * 
     * @var 
     * 
     */ 
    private $where; 

    /** 
     * Join Rules 
     * 
     * @var 
     * 
     */ 
    private $join; 

    /** 
     * OrderBy Value 
     * 
     * @var 
     * 
     */ 
    private $orderBy; 

    /** 
     * GroupBy Value 
     * 
     * @var 
     * 
     */ 
    private $groupBy; 

    /** 
     * Limit Value 
     * 
     * @var 
     * 
     */ 
    private $limit; 

    /** 
     * $_GET[] parameter 
     * 
     * @var 
     * 
     */ 
    private $page; 

    /** 
     * Row Count 
     * 
     * @var 
     * 
     */ 
    private $totalRecord; 

    /** 
     * Page Count 
     * 
     * @var 
     * 
     */ 
    private $pageCount; 

    /** 
     * Pagination Limit 
     * 
     * @var 
     * 
     */ 
    private $paginationLimit; 

    /** 
     * HTML generated 
     * 
     * @var 
     * 
     */ 
    private $html; 

    /** 
     * BasicDB Constructor 
     * 
     * @param 
     *            $host 
     * @param 
     *            $dbname 
     * @param 
     *            $username 
     * @param 
     *            $password 
     * @param string $charset             
     */ 
    public function __construct($host, $dbname, $username, $password, $charset = 'utf8') 
    { 
        parent::__construct('mysql:host=' . $host . ';dbname=' . $dbname, $username, $password); 
        $this->query('SET CHARACTER SET ' . $charset); 
        $this->query('SET NAMES ' . $charset); 
    } 

    /** 
     * Defines select table operation in sql query 
     * 
     * @param 
     *            $tableName 
     * @return $this 
     */ 
    public function select($tableName) 
    { 
        $this->sql = 'SELECT * FROM `' . $tableName . '`'; 
        $this->tableName = $tableName; 
        return $this; 
    } 

    /** 
     * Defines select row operation in sql query 
     * 
     * @param 
     *            $from 
     * @return $this 
     */ 
    public function from($from) 
    { 
        $this->sql = str_replace('*', $from, $this->sql); 
        return $this; 
    } 

    /** 
     * WHERE value at SQL query 
     * 
     * @param 
     *            $column 
     * @param 
     *            $value 
     * @param string $mark             
     * @param bool $filter             
     * @return $this 
     */ 
    public function where($column, $value = '', $mark = '=', $logical = '&&') 
    { 
        $this->where[] = array( 
            $column, 
            $value, 
            $mark, 
            $logical 
        ); 
        return $this; 
    } 

    /** 
     * Defines -or where- operation in sql query 
     * 
     * @param 
     *            $column 
     * @param 
     *            $value 
     * @param 
     *            $mark 
     * @return $this 
     */ 
    public function or_where($column, $value, $mark = '=') 
    { 
        $this->where($column, $value, $mark, '||'); 
        return $this; 
    } 

    /** 
     * Defines -join- operation in sql query 
     * 
     * @param 
     *            $targetTable 
     * @param 
     *            $joinSql 
     * @param string $joinType             
     * @return $this 
     */ 
    public function join($targetTable, $joinSql, $joinType = 'inner') 
    { 
        $this->join[] = ' ' . strtoupper($joinType) . ' JOIN ' . $targetTable . ' ON ' . sprintf($joinSql, $targetTable, $this->tableName); 
        return $this; 
    } 

    /** 
     * Defines -orderby- operation in sql query 
     * 
     * @param 
     *            $columnName 
     * @param string $sort             
     */ 
    public function orderby($columnName, $sort = 'ASC') 
    { 
        $this->orderBy = ' ORDER BY ' . $columnName . ' ' . strtoupper($sort); 
        return $this; 
    } 

    /** 
     * Defines -groupby- operation in sql query 
     * 
     * @param 
     *            $columnName 
     * @return $this 
     */ 
    public function groupby($columnName) 
    { 
        $this->groupBy = ' GROUP BY ' . $columnName; 
        return $this; 
    } 

    /** 
     * Defines -limit- operation in sql query 
     * 
     * @param 
     *            $start 
     * @param 
     *            $limit 
     * @return $this 
     */ 
    public function limit($start, $limit) 
    { 
        $this->limit = ' LIMIT ' . $start . ',' . $limit; 
        return $this; 
    } 

    /** 
     * Used for running Insert/Update/Select operations. 
     * 
     * @param bool $single             
     * @return array|mixed 
     */ 
    public function run($single = false) 
    { 
        if ($this->join) { 
            $this->sql .= implode(' ', $this->join); 
            $this->join = null; 
        } 
        $this->get_where(); 
        if ($this->groupBy) { 
            $this->sql .= $this->groupBy; 
            $this->groupBy = null; 
        } 
        if ($this->orderBy) { 
            $this->sql .= $this->orderBy; 
            $this->orderBy = null; 
        } 
        if ($this->limit) { 
            $this->sql .= $this->limit; 
            $this->limit = null; 
        } 
         
         
        $query = $this->query($this->sql); 
         
        if ($single){ 
            return $query->fetch(parent::FETCH_ASSOC); 
        } 
        else{ 
            return $query->fetchAll(parent::FETCH_ASSOC); 
        } 
             
    } 

    /** 
     * Runs where operation at query running. 
     */ 
    private function get_where() 
    { 
        if (is_array($this->where) && count($this->where) > 0) { 
            $this->sql .= ' WHERE '; 
            $where = array(); 
            foreach ($this->where as $key => $arg) { 
                if (strstr($arg[1], 'FIND_IN_SET')) { 
                    $where[] = ($key > 0 ? $arg[3] : null) . $arg[1]; 
                } else { 
                    $where[] = ($key > 0 ? $arg[3] : null) . ' `' . $arg[0] . '` ' . strtoupper($arg[2]) . ' ' . (strstr($arg[2], 'IN') ? '(' : '"') . $arg[1] . (strstr($arg[2], 'IN') ? ')' : '"'); 
                } 
            } 
            $this->sql .= implode(' ', $where); 
            $this->where = null; 
        } 
    } 

    /** 
     * Used for insert operation 
     * 
     * @param 
     *            $tableName 
     * @return $this 
     */ 
    public function insert($tableName) 
    { 
        $this->sql = 'INSERT INTO ' . $tableName; 
        return $this; 
    } 

    /** 
     * Used for setting data at insert operation. 
     * 
     * @param 
     *            $columns 
     * @return bool 
     */ 
    public function set($columns) 
    { 
        $val = array(); 
        $col = array(); 
        foreach ($columns as $column => $value) { 
            $val[] = $value; 
            $col[] = $column . ' = ? '; 
        } 
        $this->sql .= ' SET ' . implode(', ', $col); 
        $this->get_where(); 
        $query = $this->prepare($this->sql); 
        $result = $query->execute($val); 
        return $result; 
    } 

    /** 
     * Returns last added Id. 
     * 
     * @return string 
     */ 
    public function lastId() 
    { 
        return $this->lastInsertId(); 
    } 

    /** 
     * Used for update operation. 
     * 
     * @param 
     *            $columnName 
     * @return $this 
     */ 
    public function update($columnName) 
    { 
        $this->sql = 'UPDATE ' . $columnName; 
        return $this; 
    } 

    /** 
     * Used for Delete operation 
     * 
     * @param 
     *            $columnName 
     * @return $this 
     */ 
    public function delete($columnName) 
    { 
        $this->sql = 'DELETE FROM ' . $columnName; 
        return $this; 
    } 

    /** 
     * Used to complete delete operation. 
     * 
     * @return int 
     */ 
    public function done() 
    { 
        $this->get_where(); 
        $query = $this->exec($this->sql); 
        return $query; 
    } 

    /** 
     * Returns total result with -total- table name. 
     * 
     * @return mixed 
     */ 
    public function total() 
    { 
        if ($this->join) { 
            $this->sql .= implode(' ', $this->join); 
            $this->join = null; 
        } 
        $this->get_where(); 
        if ($this->orderBy) { 
            $this->sql .= $this->orderBy; 
            $this->orderBy = null; 
        } 
        if ($this->groupBy) { 
            $this->sql .= $this->groupBy; 
            $this->groupBy = null; 
        } 
        if ($this->limit) { 
            $this->sql .= $this->limit; 
            $this->limit = null; 
        } 
        $query = $this->query($this->sql)->fetch(parent::FETCH_ASSOC); 
        return $query['total']; 
    } 

    /** 
     * Returns pagination start and limit values. 
     * 
     * @param 
     *            $totalRecord 
     * @param 
     *            $paginationLimit 
     * @param 
     *            $pageParamName 
     * @return array 
     */ 
    public function pagination($totalRecord, $paginationLimit, $pageParamName) 
    { 
        $this->paginationLimit = $paginationLimit; 
        $this->page = isset($_GET[$pageParamName]) && is_numeric($_GET[$pageParamName]) ? $_GET[$pageParamName] : 1; 
        $this->totalRecord = $totalRecord; 
        $this->pageCount = ceil($this->totalRecord / $this->paginationLimit); 
        $start = ($this->page * $this->paginationLimit) - $this->paginationLimit; 
        return array( 
            'start' => $start, 
            'limit' => $this->paginationLimit 
        ); 
    } 

    /** 
     * Returns pagination 
     * 
     * @param 
     *            $url 
     * @return mixed 
     */ 
    public function showPagination($url, $class = 'active') 
    { 
        if ($this->totalRecord > $this->paginationLimit) { 
            for ($i = $this->page - 5; $i < $this->page + 5 + 1; $i ++) { 
                if ($i > 0 && $i <= $this->pageCount) { 
                    $this->html .= '<li class="'; 
                    $this->html .= ($i == $this->page ? $class : null); 
                    $this->html .= '"><a href="' . str_replace('[page]', $i, $url) . '">' . $i . '</a>'; 
                } 
            } 
            return $this->html; 
        } 
    } 

    /** 
     * Returns next page at pagination operation. 
     * 
     * @return bool 
     */ 
    public function nextPage() 
    { 
        return ($this->page + 1 < $this->pageCount ? $this->page + 1 : $this->pageCount); 
    } 

    /** 
     * Returns previous page at pagination operation. 
     * 
     * @return bool 
     */ 
    public function prevPage() 
    { 
        return ($this->page - 1 > 0 ? $this->page - 1 : 1); 
    } 

    /** 
     * Returns SQL query as string. 
     * 
     * @return mixed 
     */ 
    public function getSqlString() 
    { 
        return $this->sql; 
    } 
}
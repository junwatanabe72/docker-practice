<html>
  <body>
  <?php  
    session_start();
    $cart = isset($_SESSION['cart']) ? $_SESSION['cart']: [];
    if (isset($_POST["add"])){
      $product = $_POST["add"];
      @$cart[$product]++;
      $_SESSION["cart"] = $cart;
    }
  ?>
  <h1>ショッピング</h1>
  <h2>カゴの中身</h2>
    <?php 
      foreach ($cart as $key => $value ){
        echo $key . ":" . $value . "個<br>";
      }
    ?>
  <h2>商品を選ぶ</h2>
  <form method="post" action="<?php echo $_SERVER["SCRIPT_NAME"]?>">
  <input type="submit" name="add" value="きゅうり"><br>
  <input type="submit" name="add" value="とまと"><br>
  <input type="submit" name="add" value="toufu"><br>
  <br>
  <input typ="submit" name="reload" value="リロード">
  </form>
  <?php echo gethostname() ?>
  </body>
</html>
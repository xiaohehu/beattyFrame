//
//  ViewController.m
//  Playground
//
//  Created by Evan Buxton on 11/16/15.
//  Copyright © 2015 Evan Buxton. All rights reserved.
//

#import "PlaygroundViewController.h"
#import "GameScene.h"
#import "GameObject.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PlaygroundViewController ()
@property (weak, nonatomic) IBOutlet UIButton   *uib_reset;
@property (weak, nonatomic) IBOutlet UILabel    *uil_rotationDegres;
@property (weak, nonatomic) IBOutlet UIButton   *uib_Reset;

// Bottom control panel
@property (weak, nonatomic) IBOutlet UIView     *uiv_controlPanel;
@property (weak, nonatomic) IBOutlet UISlider   *uisld_degreeSlider;

@property (strong, nonatomic) NSArray   *arr_groupA;
@property (strong, nonatomic) NSArray   *arr_groupB;

@property (strong, nonatomic) NSArray *dropArr;


@end

@implementation PlaygroundViewController
{
    __weak      IBOutlet SCNView *scn_view;
    GameScene   *scene;
    GameObject  *siteModel;
    GameObject  *buildingA;
    GameObject  *buildingB;

    SCNNode     *cameraNode;
    SCNNode     *selectedNode;
    SCNNode     *nodeForRotation;
    
    SCNVector4  siteRotation;
    
    BOOL        isSelected;
    CGFloat     edgeMargin;
    CGPoint     startPoint;
    CGFloat     curZoom;
    double      orthScale;

}

- (void)viewWillAppear:(BOOL)animated {
    edgeMargin = 20;
    _uiv_controlPanel.transform = CGAffineTransformMakeTranslation(0, _uiv_controlPanel.frame.size.height + edgeMargin);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Game Scene
    scene = [[GameScene alloc] initWithView:scn_view];
    scn_view.backgroundColor = [UIColor darkGrayColor];
    
    // Setup view
    scn_view.scene = scene;
    scn_view.showsStatistics = NO;
    scn_view.delegate = self;

    [self setupCamera];
    
    // create and add a light to the scene
    [self setupPointLight];
    
    // create and add an ambient light to the scene
    [self setupAmbientLight];
    
    // Setup Game Character
    [self setupSite];
    
    [self addGestures];
    
    [self performSelector:@selector(addMoveableBuildings) withObject:nil afterDelay:0.5f];
    
    [self addLongPressToBuildings];
    
    nodeForRotation = [SCNNode node];
    [scene.rootNode addChildNode:nodeForRotation];
    [nodeForRotation addChildNode:siteModel.objectNode];

}

#pragma mark - Setup Scene
-(void)addMoveableBuildings
{
    
 
    
    buildingA = [self addBuildingNamed:@"AThenB.DAE" nodeName:nil];
    SCNNode *bbuildingV = [buildingA.objectNode childNodeWithName:@"Playground02AMax" recursively:YES];
    bbuildingV.hidden = YES;
    
    buildingB = [self addBuildingNamed:@"BThenA.DAE" nodeName:nil];
    bbuildingV = [buildingB.objectNode childNodeWithName:@"Playground01AMax" recursively:YES];
    bbuildingV.hidden = YES;
    
    
//    SCNMaterial *myStar;
//    // Use the absolute path to refer the texture image file
//    myStar.diffuse.contents = [UIImage imageNamed:@"Playground_01A.png"];
//    buildingA.objectNode.geometry.materials = @[myStar];
    
 
    //SCNGeometry *spaceship = bbuildingV.geometry;
    //spaceship.firstMaterial.normal.contents = [UIImage imageNamed:@"Playground_02A.png"];
    
    
}

-(GameObject*)addBuildingNamed:(NSString*)dAENAme nodeName:(NSString*)nodeName
{
    NSString *assetPath = [NSString stringWithFormat:@"art.scnassets/%@",dAENAme];
    GameObject *building = [[GameObject alloc] initFromScene:[SCNScene sceneNamed:assetPath] withName:nil];
    building.environmentScene = scene;
    building.objectNode.opacity = 1.0;
    [nodeForRotation addChildNode:building.objectNode];
    return building;
}

- (void)setupSite
{
    siteModel = [[GameObject alloc] initFromScene:[SCNScene sceneNamed:@"art.scnassets/FullSite.DAE"] withName:@"this"];
    siteModel.environmentScene = scene;
    [scene.rootNode addChildNode:siteModel.objectNode];
   
    siteRotation = siteModel.objectNode.rotation; // used for resetting the scene
}

- (void) setupCamera
{
    cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.zFar = 100000;
    //cameraNode.position = SCNVector3Make(-3200, 20000, 35356); //  FRONT/BACK ,  MOVE UP/DOWN   ,
    //cameraNode.eulerAngles = SCNVector3Make(100, 0, 0);
    cameraNode.camera.usesOrthographicProjection = YES;
    cameraNode.camera.orthographicScale = 15000;
    cameraNode.position = SCNVector3Make(-32000, 34000, 50000);
    cameraNode.eulerAngles = SCNVector3Make(100, 100, 0);
    [scene.rootNode addChildNode:cameraNode];
    
    // set up optional lookAt constraint for the camera
    SCNLookAtConstraint * constraint = [SCNLookAtConstraint lookAtConstraintWithTarget:cameraNode];
    //constraint.gimbalLockEnabled = YES;
    siteModel.objectNode.constraints = @[constraint];
    
    NSLog(@"position of child after rotation %f, %f", cameraNode.position.x, cameraNode.position.y);
    NSLog(@"position of child after rotation %f, %f", cameraNode.rotation.x, cameraNode.rotation.y);
    NSLog(@"cameraNode.rotation = x %g y %g z %g, w %g", cameraNode.rotation.x, cameraNode.rotation.y, cameraNode.rotation.z, cameraNode.rotation.w);
}

- (void) setupPointLight
{
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(1000, 200, -100);
}

- (void) setupAmbientLight
{
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
}

#pragma mark - Gestures

- (void)addGestures {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [scn_view addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handlePan:)];
    [scn_view addGestureRecognizer: panGesture];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scn_view.gestureRecognizers];
    scn_view.gestureRecognizers = gestureRecognizers;
    
    UITapGestureRecognizer *dtapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    dtapGesture.numberOfTapsRequired = 2;
    [scn_view addGestureRecognizer:dtapGesture];
    
    [tapGesture requireGestureRecognizerToFail:dtapGesture];
}

- (void)handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scn_view];
    NSArray *hitResults = [scn_view hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        if( ! [siteModel.objectNode childNodeWithName:result.node.name recursively:YES])
        {
            selectedNode = result.node;
            [self node:result.node isActive:YES];
        }
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer*)gestureRecognize
{
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scn_view];
    NSArray *hitResults = [scn_view hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        selectedNode = result.node;
        
        if ([result.node.name isEqualToString:@"Playground01AMax001"]) {
            
            SCNNode *bbuildingV = [buildingA.objectNode childNodeWithName:@"Playground02AMax" recursively:YES];
            bbuildingV.hidden = NO;
            
            SCNNode *bbuildingVV = [buildingA.objectNode childNodeWithName:@"Playground01AMax001" recursively:YES];
            bbuildingVV.hidden = YES;
            
        } else if ([result.node.name isEqualToString:@"Playground02AMax"]) {
            
            SCNNode *bbuildingV = [buildingA.objectNode childNodeWithName:@"Playground02AMax" recursively:YES];
            bbuildingV.hidden = YES;
            
            SCNNode *bbuildingVV = [buildingA.objectNode childNodeWithName:@"Playground01AMax001" recursively:YES];
            bbuildingVV.hidden = NO;
        }
        
        
        if ([result.node.name isEqualToString:@"Playground01AMax"]) {
            
            SCNNode *bbuildingV = [buildingB.objectNode childNodeWithName:@"Playground02AMax001" recursively:YES];
            bbuildingV.hidden = NO;
            
            SCNNode *bbuildingVV = [buildingB.objectNode childNodeWithName:@"Playground01AMax" recursively:YES];
            bbuildingVV.hidden = YES;
            
        } else if ([result.node.name isEqualToString:@"Playground02AMax001"]) {
            
            SCNNode *bbuildingV = [buildingB.objectNode childNodeWithName:@"Playground02AMax001" recursively:YES];
            bbuildingV.hidden = YES;
            
            SCNNode *bbuildingVV = [buildingB.objectNode childNodeWithName:@"Playground01AMax" recursively:YES];
            bbuildingVV.hidden = NO;
        }
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    //CGPoint point = [gesture velocityInView:self.view];
    //NSLog(@"handlePan is selected");

    CGPoint p = [gesture velocityInView:scn_view];
    NSArray *hitResults = [scn_view hitTest:p options:nil];
    
    
    SCNHitTestResult *hit = [hitResults firstObject];
    SCNVector3 hitPosition = hit.worldCoordinates;
    CGFloat hitPositionZ = [scn_view projectPoint: hitPosition].z;
    
    CGPoint location = [gesture locationInView:scn_view];
    CGPoint prevLocation = [gesture translationInView:scn_view];

    if ( !isSelected) {
        if (p.x > 0)
        {
            // user dragged towards the right
            [nodeForRotation runAction:[SCNAction repeatAction:[SCNAction rotateByX:0 y:p.x/10000 z:0 duration:0.23] count:1]];
        } else {
            // user dragged towards the left
            [nodeForRotation runAction:[SCNAction repeatAction:[SCNAction rotateByX:0 y:p.x/10000 z:0 duration:0.23] count:1]];
        }
    } else {
        
        [self moveNodebyPrePoint:prevLocation andCurPoint:location andZValue:hitPositionZ andNode:selectedNode];
    }
}

- (void)moveNodebyPrePoint:(CGPoint)prePoint andCurPoint:(CGPoint)curPointn andZValue:(float)zValue andNode:(SCNNode *)node {
    
    
    SCNVector3 location_3d = [scn_view unprojectPoint:SCNVector3Make(curPointn.x, curPointn.y, zValue)];
    SCNVector3 prevLocation_3d = [scn_view unprojectPoint:SCNVector3Make(prePoint.x, prePoint.y, zValue)];
    
    CGFloat x_var = location_3d.x - prevLocation_3d.x;
    CGFloat y_var = location_3d.y - prevLocation_3d.y;
    
    
#warning make the -y_var added to node's z position
    node.position = SCNVector3Make(node.position.x + x_var, node.position.y , node.position.z - y_var);
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        // Reset the last scale, necessary if there are multiple objects with different scales
        curZoom = [gestureRecognizer scale];
        orthScale = cameraNode.camera.orthographicScale;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        if ((curZoom > 1.0) && (curZoom < 3.0)) {
            orthScale = orthScale + curZoom*-200;
            NSLog(@"zooming in %f",orthScale);
            
        } else if ((curZoom > 0.5) && (curZoom < 1.0)) {
            orthScale = orthScale + curZoom*400;
            NSLog(@"zooming out %f",orthScale);
        }
        cameraNode.camera.orthographicScale = orthScale;
    }
}

- (void)addLongPressToBuildings {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnTarget:)];
    longPress.minimumPressDuration = 0.3;
    longPress.allowableMovement = YES;
    [scn_view addGestureRecognizer:longPress];
}

- (void)longPressOnTarget:(UILongPressGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView: scn_view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        startPoint = point;
        
        NSArray *hitResults = [scn_view hitTest:point options:nil];
        
        // check that we clicked on at least one object
        if([hitResults count] > 0){
            // retrieved the first clicked object
            SCNHitTestResult *result = [hitResults objectAtIndex:0];
            
            if( ! [siteModel.objectNode childNodeWithName:result.node.name recursively:YES])
            {
                selectedNode = result.node;
                [self node:selectedNode isActive:YES];
            }
        }
    }
    
    /*
     * Long press and move to change building's position
     */
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        SCNVector3 projectedPlaneCenter = [scn_view projectPoint:scn_view.scene.rootNode.position];
        float projectedDepth = projectedPlaneCenter.y;
        [self moveNodebyPrePoint:startPoint andCurPoint:point andZValue:projectedDepth andNode:selectedNode.parentNode];
        
        startPoint = point;
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        startPoint = CGPointZero;
        isSelected = NO;
        //[self node:selectedNode isActive:NO];
    }
}

#pragma mark - Actions

- (IBAction)tapDoneButton:(id)sender {
    isSelected = NO;
    [UIView animateWithDuration:0.33 animations:^(void){
        selectedNode.opacity = 1.0;
    }];
    [self controlPanelShouldAppear:NO];
    [self node:selectedNode isActive:NO];
}

- (IBAction)tapDeleteButton:(id)sender {
    [selectedNode removeFromParentNode];
    selectedNode.opacity = 1.0;
    selectedNode = nil;
    isSelected = NO;
    [self controlPanelShouldAppear:NO];
}

- (IBAction)degreeSliderChangeValue:(id)sender
{
#warning Change the pivot to make rotation direction correct
/*
 Got the idea from here:
 http://stackoverflow.com/questions/25295614/scenekit-rotate-and-animate-a-scnnode
 */
    selectedNode.pivot = SCNMatrix4MakeRotation(M_PI_2, 1, 0, 0);
    selectedNode.rotation = SCNVector4Make(0, 1, 0, DEGREES_TO_RADIANS(_uisld_degreeSlider.value));
    
    
    _uil_rotationDegres.text = [NSString stringWithFormat:@"%i°",(int)_uisld_degreeSlider.value];
}

-(IBAction)reset:(id)sender
{
    static const CGFloat duration = 0.33;
    //reset the camera
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration: duration];
    cameraNode.camera.orthographicScale = 15000;
    [SCNTransaction commit];
    //reset the angle
    [nodeForRotation runAction:[SCNAction rotateToAxisAngle:siteRotation duration: duration]];
    [self controlPanelShouldAppear:NO];
    
    [selectedNode removeFromParentNode];
    [buildingA.objectNode removeFromParentNode];
    [buildingB.objectNode removeFromParentNode];
    buildingB=nil;
    buildingA=nil;
    [self addMoveableBuildings];
//    [nodeForRotation removeFromParentNode];
//    nodeForRotation=nil;
}

- (void)node:(SCNNode *)node isActive:(BOOL)active
{
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:0.5];
    
    SCNMaterial *material = node.geometry.firstMaterial;
    
    if (active) {
        selectedNode = node;
        isSelected = YES;
        
        [UIView animateWithDuration:0.33 animations:^(void){
            _uiv_controlPanel.transform = CGAffineTransformIdentity;
        }];
        
        material.emission.contents = [UIColor redColor];
    } else {
        selectedNode = nil;
        isSelected = NO;
        _uisld_degreeSlider.value = 0;
        material.emission.contents = [UIColor blackColor];
    }
    
    [SCNTransaction commit];
}

-(void)controlPanelShouldAppear:(BOOL)appear
{
    [UIView animateWithDuration:0.33 animations:^(void){
        
        if (appear) {
            _uiv_controlPanel.transform = CGAffineTransformIdentity;
        } else {
            _uiv_controlPanel.transform = CGAffineTransformMakeTranslation(0, _uiv_controlPanel.frame.size.height + edgeMargin);
        }
    }];
}

#pragma mark - misc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
